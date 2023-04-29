# LOCALS

locals {
  vault_addr        = var.VAULT_ADDR
  vault_namespace   = var.VAULT_NAMESPACE
  vault_approle     = var.VAULT_APPROLE
  vault_roleid      = var.VAULT_ROLEID
  vault_secretid    = var.VAULT_SECRETID
  vault_authbackend = var.VAULT_AUTHBACKEND
}
