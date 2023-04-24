output "linux_virtual_machine_names" {
  value = azurerm_linux_virtual_machine.vm["control-plane"].name
}