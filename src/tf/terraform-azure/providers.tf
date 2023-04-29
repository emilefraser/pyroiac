# The terraform block including backend and required providers
terraform {

  #  backend "local" {
  #    path = "terraform.tfstate"
  #  }

  #   backend "azurerm" {
  #     resource_group_name  = "az-rg-tng-dev-san-01"
  #     storage_account_name = "azstgdltngdevsan01"
  #     container_name       = "tfstate"
  #     environment          = "public"
  #     key                  = "prod.terraform.tfstate"
  #   }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pyrodatica"

    workspaces {
      name = "tfstate-azure"
    }
  }


  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }

    localprovider = {
      source  = "hashicorp/local"
      version = "= 2.3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~>3.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.34.0"
    }

    #required_version = ">= 1.1.5"

  }
}

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# management group.
provider "vault" {
  address          = local.vault_addr
  namespace        = local.vault_namespace
  skip_child_token = true

  auth_login {
    path      = "auth/approle/login"
    namespace = local.vault_namespace
    parameters = {
      role_id   = local.vault_roleid
      secret_id = local.vault_secretid
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  owner = data.vault_generic_secret.ghsecret.data["user"]
  token = data.vault_generic_secret.ghsecret.data["token"]
}


provider "azuread" {
  client_id     = data.vault_generic_secret.azure_sp.data["client_id"]
  client_secret = data.vault_generic_secret.azure_sp.data["client_secret"]
  tenant_id     = data.vault_generic_secret.azure_sp.data["tenant_id"]

}

# Configure the Microsoft Azure Provider
provider "azurerm" {

  features {}

  subscription_id = data.vault_generic_secret.azure_account.data["subscription_id"]
  client_id       = data.vault_generic_secret.azure_sp.data["client_id"]
  client_secret   = data.vault_generic_secret.azure_sp.data["client_secret"]
  tenant_id       = data.vault_generic_secret.azure_sp.data["tenant_id"]

}
