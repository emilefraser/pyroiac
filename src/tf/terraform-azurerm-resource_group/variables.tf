variable "location" {
  description = "(Required) The Azure Region where the Resource Group should exist."
  type        = string
}

variable "name" {
  description = "Required)The Name which should be used for this Resource Group."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 90 && can(regex("^[a-zA-Z0-9-._\\(\\)]+[a-zA-Z0-9-_\\(\\)]$", var.name))
    error_message = "Invalid name (check Azure Resource naming restrictions for more info)."
  }
}

variable "creator" {
  type        = string
  description = "(Optional) Adds a tag indicating the creator of this resource"
  default     = "Emile Fraser"
}

variable "project" {
  type        = string
  description = "(Optional) Adds a tag indicating the project that this resource used for"
  default     = "Internal Sales Dashboards"
}

variable "othertags" {
  description = "(Optional) A mapping of tags which should be assigned to the Resource Group."
  type        = string
  default     = ""
}

