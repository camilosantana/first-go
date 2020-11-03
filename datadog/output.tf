output "aws_integration_role_trust_policy_conditional_external_id" {
  value = datadog_integration_aws.fst_infrastructure.external_id
}

output "dashb_k8s-3519_id" {
  value = datadog_dashboard.k8s-3519.id
}

output "datadog_api_key" {
  value     = local.datadog_api_key
  sensitive = true
}
output "datadog_app_key" {
  value     = local.datadog_app_key
  sensitive = true
}
