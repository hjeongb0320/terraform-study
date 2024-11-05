resource "azurerm_virtual_network" "vn" {
  name                = var.resource_label
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

resource "azurerm_subnet" "gateway_sn" {
  name                 = "applicationGateway_subnet"
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn.name
}

resource "azurerm_subnet" "redis_sn" {
  name                 = "redis_subnet"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn.name
}

resource "azurerm_subnet" "db_sn" {
  name                 = "postgresql_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "postgresql_delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}