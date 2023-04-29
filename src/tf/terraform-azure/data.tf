# DATA

data "vault_generic_secret" "ghsecret" {
  path = "kv/github-emilefraser"
}

# firstly get the secret value of the account
data "vault_generic_secret" "azure_account" {
  path = "kv/azure-account"
}

# then get the secret vaulue of the service principal
data "vault_generic_secret" "azure_sp" {
  path = "kv/azure-sp"
}
