terraform init -backend-config=$TERRAFORM_SHARED_STATE_FILE_PATH
terraform apply --var-file=env_input/dev.tfvars  --auto-approve
