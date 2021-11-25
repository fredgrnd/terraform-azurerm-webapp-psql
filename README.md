# WebAPP/PSQL Terraform module

Provide an Azure Webapp with PSQL Flexible server

## Required

* Azure Account
* Azure DNS zone

## How to Use

Create `main.tf` file like this:

```hcl
module "testwebapp" {
  source = "app.terraform.io/FredGRND/webapp-psql/azurerm"

  version = "~> 0.0.5"

  env          = "lab"
  project_name = "testwebapp"

  dns_resource_group_name = "core"
  dns_zone_name           = "az.fredgrnd.com"
  webapp_hostname         = "testwebapp"

  app_service_plan_size = "P1v2"
  app_service_plan_tier = "PremiumV2"

  tags = {
    environnement = "labo"
    team          = "FredGRND"
    project       = "terraform_testapp"
  }

  ## PostgreSQL
  postgresql_firewall_list = {}

  # Main Slot
  webapp_main_site_config_linux_fx_version = "DOCKER|nginx:latest"
  webapp_main_app_settings = {}
}
```

## Module Variables

### Required Inputs

These variables must be set in the module block when using this module.

#### **dns_resource_group_name** `string`

*Description*: (Required) Specifies the resource group where the DNS Zone (parent resource) exists.Changing this forces a new resource to be created.

#### **dns_zone_name** `string`

*Description*: (Required) Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created.

#### **env** `string`

*Description*: (Required) Project Environment (dev,staging,production)

#### **postgresql_firewall_list** `map(any)`

*Description*: (Required) Specifies a list of IP

#### **project_name** `string``

*Description*: (Required) Project Name

#### **tags** `map(any)`

*Description*: (Optional) A mapping of tags to assign to the resource.

#### **webapp_hostname** `string`

*Description*: (Required) Specifies the Custom Hostname to use for the App Service, example `www.example.com`. Changing this forces a new resource to be created.

### Optional Inputs

These variables have default values and don't have to be set to use this module. You may set these variables to override their default values.

#### **app_service_plan_size** `string`

*Description*: (Required) Specifies the plan's instance size.

Default: `"P2v2"`

#### **app_service_plan_tier** `string`

*Description*: (Required) Specifies the plan's pricing tier.

Default: `"PremiumV2"`

#### **dns_ttl** `string`

*Description*: (Required) The Time To Live (TTL) of the DNS record in seconds.

Default: `"300"`

#### **location** `string`

*Description*: (Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.

Default: `"francecentral"`

#### **postgresql_sku_name** `string`

*Description*: (Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the tier + name pattern (e.g. `B_Standard_B1ms`, `GP_Standard_D2s_v3`, `MO_Standard_E4s_v3`)

Default: `"B_Standard_B1ms"`

#### **postgresql_backup_retention_day** `string`

*Description*: (Optional) Backup retention days for the server, supported values are between `7` and `35` days.

Default: `"7"`

#### **postgresql_database_main_charset** `string`

*Description*: (Optional) Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created.

Default: `"UTF8"`

#### **postgresql_database_main_collation** `string`

*Description*: (Optional) Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Note that Microsoft uses different notation - en-US instead of en_US. Changing this forces a new resource to be created.

Default: `"English_United States.1252"`

#### **postgresql_database_main_name** `string`

*Description*: (Optional) Specifies the name of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created.

Default: `"smart"`

#### **postgresql_storage_mb** `string`

*Description*: (Optional) The max storage allowed for the PostgreSQL Flexible Server. Possible values are `32768`, `65536`, `131072`, `262144`, `524288`, `1048576`, `2097152`, `4194304`, `8388608`, `16777216`, and `33554432`.

Default: `"32768"`

#### **postgresql_version** `string`

*Description*: (Optional) The version of PostgreSQL Flexible Server to use. Possible values are `11`,`12` and `13`. Required when create_mode is Default. Changing this forces a new PostgreSQL Flexible Server to be created.

Default: `"11"`

#### **webapp_app_service_slot_name** `string`

*Description*: (Required) The name of the App Service Slot which should be promoted to the Production Slot within the App Service.

Default: `"maintenance"`

#### **webapp_logs_retention_in_days** `string`

*Description*: (Required) The number of days to retain logs for.

Default: `"7"`

#### **webapp_logs_retention_in_mb** `string`

*Description*: (Required) The maximum size in megabytes that http log files can use before being removed.

Default: `"30"`

#### **webapp_main_app_settings** `map`

Description: (Optional) A key-value pair of App Settings for main slot.

Default: `{}`

#### **webapp_main_site_config_app_command_line** `string`

*Description*: (Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0 for main slot

Default: `""`

#### **webapp_main_site_config_linux_fx_version** `string`

*Description*: (Optional) Linux App Framework and version for the App Service for main slot

Default: `""`

#### **webapp_main_site_config_number_of_workers** `string`

*Description*: (Optional) The scaled number of workers (for per site scaling) of this App Service.

Default: `"2"`

#### **webapp_maintenance_app_settings** `map`

*Description*: (Optional) A key-value pair of App Settings.

Default: `{}`

#### **webapp_maintenance_site_config_app_command_line** `string`

*Description*: (Optional) App command line to launch, e.g. /sbin/myserver -b 0.0.0.0 for maintenance slot

Default: `""`

#### **webapp_maintenance_site_config_linux_fx_version** `string`

*Description*: (Optional) Linux App Framework and version for the App Service for maintenance slot

Default: `""`
