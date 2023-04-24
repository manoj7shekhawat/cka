output "linux_virtual_machine_names" {
  value = values(azurerm_linux_virtual_machine.vm)[*].name
}

output "linux_virtual_machine_public_ip_address" {
    value = values(azurerm_linux_virtual_machine.vm)[*].public_ip_address
}

output "linux_virtual_machine_private_ip_address" {
  value = values(azurerm_linux_virtual_machine.vm)[*].private_ip_address
}