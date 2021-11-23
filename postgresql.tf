## Login/Password Random Generation
resource "random_password" "user" {
  length  = 16
  special = false
}

resource "random_password" "password" {
  length      = 16
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

## PostgreSQL Server
resource "azurerm_postgresql_server" "main" {
  name                = "${var.project_name}-${var.env}-psql"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = var.postegresql_sku_name

  storage_mb                   = var.postgresql_storage_mb
  backup_retention_days        = var.postgresql_backup_retention_day
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled

  administrator_login          = random_password.user.result
  administrator_login_password = random_password.password.result
  version                      = var.postgresql_version
  ssl_enforcement_enabled      = true

  tags = var.tags
}

## PostgreSQL Config
resource "azurerm_postgresql_configuration" "pg_qs_query_capture_mode" {
  name                = "pg_qs.query_capture_mode"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  value               = "ALL"
}

resource "azurerm_postgresql_configuration" "pgms_wait_sampling_query_capture_mode" {
  name                = "pgms_wait_sampling.query_capture_mode"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  value               = "ALL"
}

## Azure Firewall Rules
resource "azurerm_postgresql_firewall_rule" "azure_network" {
  name                = "Azure"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

## Firewall List
resource "azurerm_postgresql_firewall_rule" "list" {
  for_each            = var.postgresql_firewall_list
  name                = each.key
  start_ip_address    = each.value
  end_ip_address      = each.value
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
}

## Databases
resource "azurerm_postgresql_database" "main" {
  name                = var.postgresql_database_main_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.main.name
  charset             = var.postgresql_database_main_charset
  collation           = var.postgresql_database_main_collation
}

## Put secrets to Azure KeyVault
resource "azurerm_key_vault_secret" "azure-postgresql-username" {
  name         = "azure-postgresql-username"
  value        = "${azurerm_postgresql_server.main.administrator_login}@${azurerm_postgresql_server.main.name}"
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "azure-postgresql-password" {
  name         = "azure-postgresql-password"
  value        = azurerm_postgresql_server.main.administrator_login_password
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}