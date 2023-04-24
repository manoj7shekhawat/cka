location = "North Europe"

resource_groups = {
  "backend" = {
    name = "infra"
  }
}

network = {
  vnet_name          = "cks-vnet"
  vnet_address_space = ["10.0.0.0/16"]

  subnet_name             = "internal"
  subnet_address_prefixes = ["10.0.2.0/24"]

  nic_name = "cks-nic"
}

compute = {
  vm_names = ["control-plane"]
  vm_size = "Standard_D2s_v3"

  admin_username = "mshekhawat"

  source_image_reference = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "86-gen2"
    version   = "latest"
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}