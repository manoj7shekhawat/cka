variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "compute" {
  type = object({
    vm_names       = list(string)
    vm_size        = string
    admin_username = string
    admin_password = string
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
  })
}

variable "network_interface_ids" {
  type = list(string)
}