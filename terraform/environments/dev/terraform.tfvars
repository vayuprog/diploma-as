# Replace with your values before running terraform apply
region       = "eu-central-1"
name         = "juice-lab"
cluster_name = "juice-shop-dev"

# Your public IP with /32 — run: curl -s ifconfig.me && echo "/32"
allowed_cidr = "REPLACE_WITH_YOUR_IP/32"

azs = ["eu-central-1a", "eu-central-1b"]
