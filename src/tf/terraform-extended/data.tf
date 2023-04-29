# DATA

# from variable.tf
#variable "vpc_id" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

# from main/resources/{resource}.tf
#
# resource "aws_subnet" "example" {
#  vpc_id            = data.aws_vpc.selected.id
#  availability_zone = "us-west-2a"
#  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
# }

# data "github_repository_pull_requests" "pull_requests" {
#   base_repository = "example-repository"
#   base_ref        = "main"
#   state           = "open"
# }

# from main/resources/{resource}.tf
#
# module “preview-environment” {
# for_each        = data.github_repository_pull_requests.pull_requests.results
#  name            = each.value.title
#  commit_sha      = each.value.head_sha
#  // ...


#}


resource "vault_mount" "kvv2" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
  #num_sequential_successes    = 3
  #num_seconds_between_tests   = 1
  #max_cred_validation_seconds = 100
}


data "vault_kv_secret_v2" "example" {
  mount = vault_mount.kvv2.path
  name  = "github-emilefraser"
}
