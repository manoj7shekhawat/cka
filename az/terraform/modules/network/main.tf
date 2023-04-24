resource "azurerm_virtual_network" "vnet" {
  name                = var.network.vnet_name
  address_space       = var.network.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.network.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.network.subnet_address_prefixes
}

resource "azurerm_public_ip" "pip" {
  name                = var.network.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags     = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = var.network.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
    private_ip_address_allocation = "Dynamic"
  }

  tags     = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network.nsg.name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = var.network.nsg.security_rule.name
    priority                   = var.network.nsg.security_rule.priority
    direction                  = var.network.nsg.security_rule.direction
    access                     = var.network.nsg.security_rule.access
    protocol                   = var.network.nsg.security_rule.protocol
    source_port_range          = var.network.nsg.security_rule.source_port_range
    destination_port_range     = var.network.nsg.security_rule.destination_port_range
    source_address_prefix      = var.network.nsg.security_rule.source_address_prefix
    destination_address_prefix = var.network.nsg.security_rule.destination_address_prefix
  }

  tags     = var.tags
}