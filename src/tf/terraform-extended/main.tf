# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# management group.

provider "vault" {
  address          = local.vault_address
  namespace        = "admin"
  skip_child_token = true

  auth_login {
    path      = "auth/approle/login"
    namespace = "admin"
    parameters = {
      role_id   = "59857134-be2c-d95d-65e9-33567199591e" #local.vault_roleid
      secret_id = "e3657af4-424f-e8d6-3789-57393e2f0a91" #local.vault_secretid
    }
  }
}



# # Configure the GitHub Provider
# provider "github" {
#   token = data.vault_generic_secret.my_secret.data["token"] #"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"
#   owner = var.github_username
# }

# resource "github_repository" "gh_repo" {
#   name        = var.github_repo
#   description = "My awesome codebase"
#   visibility  = "public"
# }
