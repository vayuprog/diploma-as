#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_DIR="$SCRIPT_DIR/../terraform/environments/dev"

echo "=== Juice Shop Security Lab — SHUTDOWN ==="
echo ""
echo "This will DESTROY all AWS resources."
echo "Cost when down: ~\$0.01/day (S3 + DynamoDB state only)"
echo ""
read -rp "Are you sure? (yes/no): " CONFIRM
[[ "$CONFIRM" != "yes" ]] && echo "Aborted." && exit 0

echo ""
echo "[1/2] Destroying Kubernetes resources..."
kubectl delete ingress juice-shop -n juice-shop --ignore-not-found 2>/dev/null || true
# Give ALB controller time to clean up the ALB before destroying VPC
sleep 30

echo "[2/2] Destroying Terraform infrastructure..."
cd "$TF_DIR"
terraform destroy -auto-approve

echo ""
echo "=== All resources destroyed ==="
echo "Cost: ~\$0.01/day"
echo ""
echo "To bring everything back up: bash scripts/up.sh"
