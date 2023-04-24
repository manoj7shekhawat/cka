resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_groups

  name     = each.value.name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage.name
  resource_group_name             = azurerm_resource_group.resource_group["backend"].name
  location                        = azurerm_resource_group.resource_group["backend"].location
  account_tier                    = var.storage.tier
  account_replication_type        = var.storage.replication_type
  allow_nested_items_to_be_public = false
  tags                            = var.tags
  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "containers" {
  for_each = toset(var.storage.container_names)

  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.storage.container_type
}
