variable location {
  type = string
}

variable resource_group_name {
  type = string
}

variable "network" {
  type = object({
    vnet_name = string
    vnet_address_space = list(string)

    subnet_name = string
    subnet_address_prefixes = list(string)

    nic_name = string
  })
}