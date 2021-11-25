## Globals Variables
variable "location" {
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  default     = "francecentral"
}

variable "env" {
  description = "(Required) Project Environnement (dev,staging,production)"
}

variable "project_name" {
  description = "(Required) Project Name"
}

## AppService Plan
variable "app_service_plan_tier" {
  description = "(Required) Specifies the plan's pricing tier."
  default     = "PremiumV2"
}

variable "app_service_plan_size" {
  description = "(Required) Specifies the plan's instance size."
  default     = "P2v2"
}

## Webapp
variable "webapp_logs_retention_in_days" {
  description = "(Required) The number of days to retain logs for."
  default     = "7"
}

variable "webapp_logs_retention_in_mb" {
  description = "(Required) The maximum size in megabytes that http log files can use before being removed."
  default     = "30"
}

variable "webapp_maintenance_app_settings" {
  description = "(Optional) A key-value pair of App Settings."
  default     = {}
}

variable "webapp_maintenance_site_config_app_command_line" {
  description = "(Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0 for maintenance slot"
  default     = ""
}

variable "webapp_maintenance_site_config_linux_fx_version" {
  description = "(Optional) Linux App Framework and version for the App Service for maintenace slot"
  default     = ""
}

variable "webapp_main_site_config_app_command_line" {
  description = "(Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0 for main slot"
  default     = ""
}

variable "webapp_main_site_config_linux_fx_version" {
  description = "(Optional) Linux App Framework and version for the App Service for main slot"
  default     = ""
}

variable "webapp_main_app_settings" {
  description = "(Optional) A key-value pair of App Settings for main slot."
  default     = {}
}

variable "webapp_app_service_slot_name" {
  description = "(Required) The name of the App Service Slot which should be promoted to the Production Slot within the App Service."
  default     = "maintenance"
}

variable "webapp_hostname" {
  description = "(Required) Specifies the Custom Hostname to use for the App Service, example www.example.com. Changing this forces a new resource to be created."
}

variable "webapp_main_site_config_number_of_workers" {
  description = "(Optional) The scaled number of workers (for per site scaling) of this App Service."
  default     = "2"
}

## DNS

variable "dns_zone_name" {
  description = "(Required) Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created."
}

variable "dns_resource_group_name" {
  description = "(Required) Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
}

variable "dns_ttl" {
  description = "(Required) The Time To Live (TTL) of the DNS record in seconds."
  default     = "300"
}

## PostgreSQL
variable "postegresql_sku_name" {
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. B_Standard_B1ms, GP_Standard_D2s_v3, MO_Standard_E4s_v3)"
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage_mb" {
  description = "(Optional) Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 16777216 MB(16TB) for General Purpose/Memory Optimized SKUs. For more information see the product documentation."
  default     = "32768"
}

variable "postgresql_backup_retention_day" {
  description = "(Optional) Backup retention days for the server, supported values are between 7 and 35 days."
  default     = "7"
}

variable "postgresql_version" {
  description = "(Required) Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11. Changing this forces a new resource to be created."
  default     = "11"
}

variable "postgresql_firewall_list" {
  description = "(Required) Specifies a list of IP"
  type        = map(any)
}

## Databases
variable "postgresql_database_main_name" {
  description = "(Required) Specifies the name of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created."
  default     = "smart"
}

variable "postgresql_database_main_charset" {
  description = "(Required) Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created."
  default     = "UTF8"
}

variable "postgresql_database_main_collation" {
  description = " (Required) Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Note that Microsoft uses different notation - en-US instead of en_US. Changing this forces a new resource to be created."
  default     = "English_United States.1252"
}

## Tags
variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
}