# create secret
resource "aws_secretsmanager_secret" "api" {
  name = "datadog/production/k8s-apikeys"
  tags = module.tag_datadog.tags
}

# pull secret
data "aws_secretsmanager_secret_version" "api" {
  secret_id = aws_secretsmanager_secret.api.arn
}

#json parse secrets data source into two locals
locals {
  datadog_api_key = jsondecode(data.aws_secretsmanager_secret_version.api.secret_string)["datadog_api_key"]
  datadog_app_key = jsondecode(data.aws_secretsmanager_secret_version.api.secret_string)["datadog_app_key"]
}

# tagging
module "tag_datadog" {
  source     = "github.com/procore/terraform-aws-modules.git//modules/tagging?ref=v0.1.9"
  pz         = "us00"
  env        = "production"
  app        = "k8s-monitoring"
  project    = "continuous_deployment"
  semver2    = "v0.0.0"
  owner      = "camilosantana"
  createdby  = "camilosantana"
  deploy     = "terraform"
  costcenter = "4200"
  note       = "this resource supports datadog monitoring of fst kubernetes services"
  attributes = ["k8s", "kubernetes", "datadog", "devops"]
  delimiter  = "-"
}
