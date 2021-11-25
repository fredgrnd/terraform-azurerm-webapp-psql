output "psql_host" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "psql_username" {
  value = "${azurerm_postgresql_flexible_server.main.administrator_login}@${azurerm_postgresql_flexible_server.main.name}"
}

output "psql_password" {
  value = azurerm_postgresql_flexible_server.main.administrator_password
}

output "psql_database" {
  value = azurerm_postgresql_flexible_server.main.name
}

output "psql_port" {
  value = "5432"
}