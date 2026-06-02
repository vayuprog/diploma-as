#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_DIR="$SCRIPT_DIR/../terraform/environments/dev"
K8S_DIR="$SCRIPT_DIR/../k8s"

echo "=== Juice Shop Security Lab — STARTUP ==="
echo ""

# ── 1. Terraform ──────────────────────────────────────────────────────────────
echo "[1/5] Applying Terraform infrastructure (~15 min for EKS)..."
cd "$TF_DIR"
terraform apply -auto-approve

CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw region 2>/dev/null || echo "eu-central-1")
LB_ROLE_ARN=$(terraform output -raw lb_controller_role_arn)
VPC_ID=$(terraform output -raw vpc_id)
ALB_SG_ID=$(terraform output -raw alb_sg_id)
WAF_ARN=$(terraform output -raw waf_acl_arn)
CERT_ARN=$(terraform output -raw acm_certificate_arn)

# ── 2. kubectl ────────────────────────────────────────────────────────────────
echo ""
echo "[2/5] Configuring kubectl..."
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

# ── 3. aws-load-balancer-controller ──────────────────────────────────────────
echo ""
echo "[3/5] Installing aws-load-balancer-controller..."
helm repo add eks https://aws.github.io/eks-charts 2>/dev/null || true
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$CLUSTER_NAME" \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=$LB_ROLE_ARN" \
  --set region="$REGION" \
  --set vpcId="$VPC_ID" \
  --wait --timeout 3m

# ── 4. Kubernetes manifests ───────────────────────────────────────────────────
echo ""
echo "[4/5] Deploying Juice Shop..."

# Patch ingress with fresh SG and WAF ARNs
sed -i.bak \
  -e "s|alb.ingress.kubernetes.io/security-groups:.*|alb.ingress.kubernetes.io/security-groups: \"$ALB_SG_ID\"|" \
  -e "s|alb.ingress.kubernetes.io/wafv2-acl-arn:.*|alb.ingress.kubernetes.io/wafv2-acl-arn: \"$WAF_ARN\"|" \
  -e "s|alb.ingress.kubernetes.io/certificate-arn:.*|alb.ingress.kubernetes.io/certificate-arn: \"$CERT_ARN\"|" \
  "$K8S_DIR/ingress.yaml"
rm -f "$K8S_DIR/ingress.yaml.bak"

kubectl apply -f "$K8S_DIR/namespace.yaml"
kubectl apply -f "$K8S_DIR/networkpolicy.yaml"
kubectl apply -f "$K8S_DIR/deployment.yaml"
kubectl apply -f "$K8S_DIR/service.yaml"

echo "Waiting for pod to be ready (~90s for init container)..."
kubectl rollout status deployment/juice-shop -n juice-shop --timeout=3m

kubectl apply -f "$K8S_DIR/ingress.yaml"

# ── 5. Falco ──────────────────────────────────────────────────────────────────
echo ""
echo "[5/5] Installing Falco..."
helm repo add falcosecurity https://falcosecurity.github.io/charts 2>/dev/null || true
helm repo update

helm upgrade --install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  -f "$K8S_DIR/falco/values.yaml" \
  --wait --timeout 3m

# ── DNS update reminder ───────────────────────────────────────────────────────
echo ""
echo "Waiting for ALB DNS to be assigned..."
until kubectl get ingress juice-shop -n juice-shop \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null | grep -q "."; do
  sleep 5
done

ALB_DNS=$(kubectl get ingress juice-shop -n juice-shop \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
ALB_IPS=$(dig +short "$ALB_DNS" | tr '\n' ' ')

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           UPDATE GODADDY DNS (takes ~5 min)             ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║                                                          ║"
printf "║  CNAME  www  →  %-40s║\n" "$ALB_DNS"
echo "║                                                          ║"
echo "║  A records for @:                                        ║"
for IP in $ALB_IPS; do
  printf "║    A  @  →  %-44s║\n" "$IP"
done
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "=== Startup complete! ==="
echo "Site: https://vayuprogdimloma.biz (after DNS update)"
