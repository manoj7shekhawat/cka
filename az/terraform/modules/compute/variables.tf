variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "compute" {
  type = object({
    vms = map(object({
      name = string
      size = string
    }))
    admin_username = string
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

variable "network_interfaces" {
  type = any
}

variable "admin_password" {
  type = string
  nullable  = false
  sensitive = true
}

# TAGS
variable "tags" {
  type = object({
    environment            = string
  })
}