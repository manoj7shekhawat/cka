variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "network" {
  type = object({
    vnet_name          = string
    vnet_address_space = list(string)

    subnet_name             = string
    subnet_address_prefixes = list(string)

    pip_name = string
    nic_name = string

    nsg = object({
      name                = string
      security_rule = object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      })
    })
  })
}

# TAGS
variable "tags" {
  type = object({
    environment            = string
  })
}