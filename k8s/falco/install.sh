#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-eu-central-1}"

helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm upgrade --install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  -f "$(dirname "$0")/values.yaml" \
  --set driver.kind=ebpf \
  --set falcosidekick.config.aws.cloudwatchlogs.region="${REGION}" \
  --wait \
  --timeout 5m

echo "Falco installed. Pods:"
kubectl get pods -n falco

echo ""
echo "To test a Falco alert, run:"
echo "  kubectl exec -n juice-shop \$(kubectl get pod -n juice-shop -l app=juice-shop -o name | head -1) -- /bin/sh"
echo "Then check CloudWatch: /aws/falco/juice-lab"
