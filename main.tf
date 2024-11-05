terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_label
  location = var.location
}

module "vpc" {
  source              = "./modules/vpc"
  resource_label      = var.resource_label
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "redis" {
  source              = "./modules/redis"
  resource_label      = var.resource_label
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vpc.redis_subnet_id
  virtual_network_id  = module.vpc.virtual_network_id
}

module "database" {
  source              = "./modules/database"
  resource_label      = var.resource_label
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_id  = module.vpc.virtual_network_id
  subnet_id           = module.vpc.postgresql_subnet_id
  db_host             = var.db_host
  db_password         = var.db_password
}

module "virtual_machine" {
  source              = "./modules/virtual_machine"
  resource_label      = var.resource_label
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_id  = module.vpc.virtual_network_id
  subnet_id           = module.vpc.gateway_subnet_id
}
