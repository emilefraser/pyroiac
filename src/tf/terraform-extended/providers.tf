# The terraform block including backend and required providers
terraform {

   backend "local" {
     path = "terraform.tfstate"
   }

  #   backend "azurerm" {
  #     resource_group_name  = "az-rg-tng-dev-san-01"
  #     storage_account_name = "azstgdltngdevsan01"
  #     container_name       = "tfstate"
  #     environment          = "public"
  #     key                  = "prod.terraform.tfstate"
  #   }

  #backend "remote" {
  #  hostname     = "app.terraform.io"
  #  organization = "pyrodatica"

  #  workspaces {
  #    name = "pyrodatica-tfstate"
  #  }
  #}


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

    #required_version = ">= 1.1.5"

  }
}

