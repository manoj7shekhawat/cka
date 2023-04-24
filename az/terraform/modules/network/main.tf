resource "azurerm_virtual_network" "vnet" {
  name                = var.network.vnet_name
  address_space       = var.network.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.network.subnet_name
  resource_group_name  = resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.network.subnet_address_prefixes
}

resource "azurerm_network_interface" "nic" {
  name                = var.network.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network.nsg.name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = var.network.nsg.name
    priority                   = var.network.nsg.priority
    direction                  = var.network.nsg.direction
    access                     = var.network.nsg.access
    protocol                   = var.network.nsg.protocol
    source_port_range          = var.network.nsg.source_port_range
    destination_port_range     = var.network.nsg.destination_port_range
    source_address_prefix      = var.network.nsg.source_address_prefix
    destination_address_prefix = var.network.nsg.destination_address_prefix
  }

  tags     = var.tags
}