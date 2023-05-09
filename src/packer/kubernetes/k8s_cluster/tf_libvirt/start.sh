#!/bin/bash

echo "enabling terraform logs at debug level"
export TF_LOG=DEBUG
export TF_LOG_CORE=DEBUG
export TF_LOG_PATH="$HOME/repos/iac/packer/kubernetes/k8s_cluster/terraform.log"
echo "loggin enabled at $TF_LOG level to path: $TF_LOG_PATH"

echo "running plan and apply"
terraform plan -out terraform.out && terraform apply terraform.out
