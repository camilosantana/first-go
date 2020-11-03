# Datadog Config for fst-platform AWS account

This project makes use of the [Terraform Datadog provider] to codify:

- integrations
- monitors
- dashboards

## Inputs

None

## Outputs

`datadog_integration_aws.fst_infrastructure.external_id` used as a shared secret (External ID) for datadog collector, running in their AWS account, can assumeRole our `k8s-datadog_core` role and pull EC2 and other metrics from Cloudwatch.

## Terraform

### First run

bootstrap the project by running the `bootstrap.sh` script. This will:

- create the secrets metadata needed
- open default browser to AWS console / secrets

Input secret via cli (`aws secretsmanager put-secret-value`) or in the [AWS secrets console] opened above.

### Plan

`terraform plan --out=datadog.tfp`

### Apply

`terraform apply datadog.tfp`

## Automation

### Tests

| trigger                                   | CI              | test                         |
| ----------------------------------------- | --------------- | ---------------------------- |
| `on.pull_request.branches[master]`        | [datadog_plan]  | [datadog_plan] - test inline |
| pr-is-mergeable-is-approve-has-tf-comment | [datadog_apply] | [test/datadog]               |

### Automated Deployment

- Github Actions are defined in `.github/workflows/datadog`
- Dependency
  - IAM
    - policy allowing access to
      - remote state allowing read access to for planning (rw when we automate apply)
        - bucket = "fst-infrastructure"
        - key    = "datadog/terraform.tfstate"
      - read secrets in [AWS secrets console] `datadog/production/k8s-apikeys`

## Importing existing resources

1. Define resource in this project
1. Import the remote resource

    ```bash
    account_id=435246161572 # fst-infrastructure
    role_name=k8s-datadog_core # role defined in `./aws/iam`
    external_id="###################" # available in the aws console
    EXTERNAL_ID=${external_id} terraform import datadog_integration_aws.fst_infrastructure ${account_id}:${role_name}
    ```

1. Update terraform to reflect existing (`terraform plan` returns `No changes`)

[AWS secrets console]: https://console.aws.amazon.com/secretsmanager
[Terraform Datadog provider]: https://www.terraform.io/docs/providers/datadog/
[test/datadog]: /test/datadog/datadog_test.go
[datadog_plan]: /.github/workflows/datadog_plan.yml
[datadog_apply]: /.github/workflows/datadog_apply.yml
