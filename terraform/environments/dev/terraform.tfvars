# Replace with your values before running terraform apply
region       = "eu-central-1"
name         = "juice-lab"
cluster_name = "juice-shop-dev"

# Your public IP with /32 — run: curl -s ifconfig.me && echo "/32"
allowed_cidr = "45.12.25.5/32"

azs = ["eu-central-1a", "eu-central-1b"]

node_instance_type = "t3.small"
domain_name        = "vayuprogdimloma.biz"
github_repo        = "vayuprog/aws-security-lab"
