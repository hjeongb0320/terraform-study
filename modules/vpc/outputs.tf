output "redis_subnet_id" {
  value = azurerm_subnet.redis_sn.id
}

output "postgresql_subnet_id" {
  value = azurerm_subnet.db_sn.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vn.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_sn.id
}