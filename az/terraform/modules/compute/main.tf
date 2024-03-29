resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.compute.vms

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size

  disable_password_authentication = false
  admin_username                  = var.compute.admin_username
  admin_password                  = var.admin_password

  network_interface_ids = [var.network_interfaces[0]["${each.value.name}-nic"].id]

  priority        = "Spot"
  eviction_policy = "Delete"

  os_disk {
    caching              = var.compute.os_disk.caching
    storage_account_type = var.compute.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.compute.source_image_reference.publisher
    offer     = var.compute.source_image_reference.offer
    sku       = var.compute.source_image_reference.sku
    version   = var.compute.source_image_reference.version
  }
}