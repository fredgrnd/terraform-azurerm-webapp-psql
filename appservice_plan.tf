resource "azurerm_app_service_plan" "main" {
  name                = "${var.project_name}-${var.env}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true
  per_site_scaling    = true

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

  tags = var.tags
}