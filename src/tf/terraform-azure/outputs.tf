# OUTPUT

output "github_user" {
  value       = nonsensitive(data.vault_generic_secret.ghsecret.data["user"])
  description = "vault kv user"
  #sensitive   = true
}

output "github_token" {
  value       = nonsensitive(data.vault_generic_secret.ghsecret.data["token"])
  description = "vault kv data token"
  #sensitive   = true
}

output "service_principal" {
  value       = nonsensitive(data.vault_generic_secret.azure_sp.data)
  description = "client id of the service principal"
  #sensitive   = true
}

output "account" {
  value       = nonsensitive(data.vault_generic_secret.azure_account.data)
  description = "secret stored in azure-account"
  #sensitive   = true
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "name of the resource group"
}
