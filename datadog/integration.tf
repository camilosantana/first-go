# ref: https://www.terraform.io/docs/providers/datadog/

# Create a new Datadog - AWS integration
resource "datadog_integration_aws" "fst_infrastructure" {
  account_id = "435246161572"
  role_name  = "k8s-datadog_core"
  host_tags  = ["account_name:fst-platform"]
}
