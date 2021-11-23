terraform {
  required_version = "~> 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.79.1"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "=3.6.0"
    }
    random = {}
  }
}

provider "azurerm" {
  features {}
}