#!/bin/bash

### run terraform - targetted to create only the secret metadata

plan=$(mktemp)
terraform plan --target=aws_secretsmanager_secret.api --out="$plan"
terraform apply "$plan"
rm -rf "$plan"

open https://console.aws.amazon.com/secretsmanager
