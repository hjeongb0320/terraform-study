resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                          = var.resource_group_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.postgresql_dns_zone.id
  public_network_access_enabled = false
  administrator_login           = var.db_host
  administrator_password        = var.db_password
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name = "B_Standard_B1ms"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql_virtual_network_link]
}

resource "azurerm_private_dns_zone" "postgresql_dns_zone" {
  name                = "${var.resource_label}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_virtual_network_link" {
  name                  = "postgresql_link"
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
}