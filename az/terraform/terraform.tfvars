location = "North Europe"

resource_group_name = "infra"

network = {
  vnet_name          = "cks-vnet"
  vnet_address_space = ["10.0.0.0/16"]

  subnet_name             = "internal"
  subnet_address_prefixes = ["10.0.2.0/24"]

  pip_name = "my-pip"

  # Needs to updated based on the requirement
  nsg = [
    {
      nsg_name              = "control-plane-nsg"
      nic_name              = "control-plane-nic"
      ip_configuration_name = "external"
    },
    {
      nsg_name              = "worker-1-nsg"
      nic_name              = "worker-1-nic"
      ip_configuration_name = "internal"
    }
  ]

  security_rule = {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

compute = {
  # Needs to updated based on the requirement
  vms = {
    control_plane = {
      name = "control-plane"
      size = "Standard_D2s_v3"
    },
    worker_1 = {
      name = "worker-1"
      size = "Standard_DS1_v2"
    }
  }

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

tags = {
  environment = "cks"
}