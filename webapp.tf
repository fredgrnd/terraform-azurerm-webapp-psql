resource "azurerm_app_service" "main" {
  depends_on = [
    azurerm_postgresql_server.main,
  ]
  name                = "${var.project_name}-${var.env}-wa"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  https_only = true

  site_config {
    app_command_line  = var.webapp_main_site_config_app_command_line
    linux_fx_version  = var.webapp_main_site_config_linux_fx_version
    number_of_workers = var.webapp_main_site_config_number_of_workers
  }

  app_settings = merge(
    var.webapp_main_app_settings,
    {
      POSTGRES_USER            = "${azurerm_postgresql_server.main.administrator_login}@${azurerm_postgresql_server.main.name}"
      POSTGRES_HOST            = azurerm_postgresql_server.main.fqdn
      POSTGRES_PASSWORD        = azurerm_postgresql_server.main.administrator_login_password
      POSTGRES_PORT            = "5432"
      POSTGRES_DB              = azurerm_postgresql_database.main.name
    }
  )

  logs {
    http_logs {
      file_system {
        retention_in_days = var.webapp_logs_retention_in_days
        retention_in_mb   = var.webapp_logs_retention_in_mb
      }
    }
  }

  tags = var.tags
}

resource "azurerm_app_service_custom_hostname_binding" "main" {
  depends_on = [
    azurerm_dns_cname_record.main,
    azurerm_dns_txt_record.domaincheck,
  ]
  hostname            = "${var.webapp_hostname}.${var.dns_zone_name}"
  app_service_name    = azurerm_app_service.main.name
  resource_group_name = azurerm_resource_group.main.name

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.example
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "main" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.main.id

  tags = var.tags
}

resource "azurerm_app_service_certificate_binding" "main" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.main.id
  certificate_id      = azurerm_app_service_managed_certificate.main.id
  ssl_state           = "SniEnabled"
}


## DNS
resource "azurerm_dns_cname_record" "main" {
  name                = var.webapp_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = var.dns_ttl
  record              = azurerm_app_service.main.default_site_hostname

  tags = var.tags
}

resource "azurerm_dns_txt_record" "domaincheck" {
  name                = "asuid.${var.webapp_hostname}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = var.dns_ttl

  record {
    value = azurerm_app_service.main.custom_domain_verification_id
  }

  tags = var.tags
}