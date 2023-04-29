resource "github_repository" "gh_repo" {
  name        = "terraform_vault_test"
  description = "My awesome codebase"
  visibility  = "public"
}

resource "azurerm_resource_group" "rg" {
  location = "sanorth"
  name     = "rg-test-terraform"
}
