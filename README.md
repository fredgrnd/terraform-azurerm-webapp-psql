# How to Use

Create `application.tf` file like this:

```hcl
module "testwebapp" {
  source = "app.terraform.io/FredGRND/webapp-psql/azurerm"

  version = "~> 0.0.2"

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
