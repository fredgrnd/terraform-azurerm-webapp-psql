## Login/Password Random Generation
resource "random_password" "psql_user" {
  length  = 16
  special = false
}

resource "random_password" "psql_password" {
  length      = 16
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

## PostgreSQL Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "${var.project_name}-${var.env}-psql"
  resource_group_name = azurerm_resource_group.main.location
  location            = azurerm_resource_group.main.name
  version             = var.postgresql_version

  administrator_login    = random_password.psql_user.result
  administrator_password = random_password.psql_password.result
  zone                   = "1"

  storage_mb = var.postgresql_storage_mb

  sku_name = var.postegresql_sku_name

  tags = var.tags
}

## PostgreSQL Config
resource "azurerm_postgresql_flexible_server_configuration" "pg_qs_query_capture_mode" {
  name                = "pg_qs.query_capture_mode"
  server_id         = azurerm_postgresql_flexible_server.main.id
  value               = "ALL"
}

resource "azurerm_postgresql_flexible_server_configuration" "pgms_wait_sampling_query_capture_mode" {
  name                = "pgms_wait_sampling.query_capture_mode"
  server_id         = azurerm_postgresql_flexible_server.main.id
  value               = "ALL"
}

## Firewall List
resource "azurerm_postgresql_flexible_server_firewall_rule" "list" {
  for_each            = var.postgresql_firewall_list
  name                = each.key
  start_ip_address    = each.value
  end_ip_address      = each.value
  server_id         = azurerm_postgresql_flexible_server.main.id
}

## Databases
resource "azurerm_postgresql_flexible_server_database" "main" {
  name                = var.postgresql_database_main_name
  server_id         = azurerm_postgresql_flexible_server.main.id
  charset             = var.postgresql_database_main_charset
  collation           = var.postgresql_database_main_collation
}

## Put secrets to Azure KeyVault
resource "azurerm_key_vault_secret" "azure-postgresql-username" {
  name         = "azure-postgresql-username"
  value        = "${azurerm_postgresql_flexible_server.main.administrator_login}@${azurerm_postgresql_flexible_server.main.name}"
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "azure-postgresql-password" {
  name         = "azure-postgresql-password"
  value        = azurerm_postgresql_flexible_server.main.administrator_password
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}