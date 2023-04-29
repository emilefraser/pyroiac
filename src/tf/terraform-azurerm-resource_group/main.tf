resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags = { 
      creator   = var.creator
      project   = var.project
      othertags = var.othertags
  }
}