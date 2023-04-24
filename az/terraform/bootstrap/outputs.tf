output "resource_group_id" {
  value = azurerm_resource_group.resource_group["backend"].id
}

output "storage_id" {
  value = azurerm_storage_account.storage_account.id
}