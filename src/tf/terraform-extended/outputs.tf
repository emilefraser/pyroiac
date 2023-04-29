# OUTPUT

output "backend" {
  value       = nonsensitive(data.vault_kv_secret_v2.example.data_json)
  description = "vault kv data_json "
  #sensitive   = true
}

# output "role" {
#   value       = data.vault_kv_secret_v2.kv2.role
#   description = "vault_azure_access_credentials creds backend role"
# }
