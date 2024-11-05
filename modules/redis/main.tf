resource "azurerm_redis_cache" "redis" {
  name                          = var.resource_label
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = 0
  family                        = "C"
  sku_name                      = "Basic"
  non_ssl_port_enabled          = false
  public_network_access_enabled = false

  depends_on = [azurerm_private_dns_zone_virtual_network_link.redis_virtual_network_link]
}

resource "azurerm_private_endpoint" "redis_private_endpoint" {
  name                = "${var.resource_label}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "redisPrivateConnection"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "redis_dns_a_record" {
  name                = "redis"
  zone_name           = azurerm_private_dns_zone.redis_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records             = [azurerm_private_endpoint.redis_private_endpoint.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone" "redis_dns_zone" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis_virtual_network_link" {
  name                  = "redis_link"
  private_dns_zone_name = azurerm_private_dns_zone.redis_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = var.virtual_network_id
}