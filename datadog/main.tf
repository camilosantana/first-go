# Configure the Datadog provider
provider "datadog" {
  api_key = "${local.datadog_api_key}"
  app_key = "${local.datadog_app_key}"
}

provider "aws" {
  region  = "us-east-1"
  profile = "fst-infrastructure"
}

terraform {
  required_version = ">= 0.12.10"
  backend "s3" {
    bucket  = "fst-infrastructure"
    key     = "datadog/terraform.tfstate"
    region  = "us-east-1"
    profile = "fst-infrastructure"
  }
}
