output "linux_virtual_machine_names" {
  value = values(azurerm_linux_virtual_machine.vm)[*].name
}