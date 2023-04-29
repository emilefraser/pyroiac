# Variables used for the code
variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "VAULT_APPROLE" {
  type        = string
  description = "The AppRole path without the trailing slash"
  default     = ""
}

variable "VAULT_AUTHBACKEND" {
  type        = string
  description = "The AppRole path without the trailing slash"
  default     = ""
}


variable "VAULT_ROLEID" {
  type        = string
  description = "The AppRole role ID"
  default     = ""
}

variable "VAULT_SECRETID" {
  type        = string
  description = "The AppRole secret ID"
  sensitive   = true
  default     = ""
}

variable "VAULT_NAMESPACE" {
  type        = string
  description = "The Vault namespace"
  default     = ""
}

variable "VAULT_ADDR" {
  type        = string
  description = "The Vault server address"
  default     = ""
}

variable "vault_secret_backend_path" {
  type        = string
  description = "Thr vault auth backend path"
  default     = ""
}
