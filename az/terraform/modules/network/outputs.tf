output "network_interface_id" {
  value = azurerm_network_interface.nic["control-plane-nic"].id
}

output "network_interfaces" {
  value = azurerm_network_interface.nic[*]
}