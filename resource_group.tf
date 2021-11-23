resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.env}"
  location = var.location
  tags     = var.tags
}