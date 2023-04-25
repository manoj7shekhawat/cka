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
  for_each = {for vm in var.network.nsg:  vm.nic_name => vm}

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = each.key == "control-plane-nic" ? azurerm_public_ip.pip.id : null
    private_ip_address_allocation = "Dynamic"
  }

  tags     = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network.nsg[0].nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = var.network.security_rule.name
    priority                   = var.network.security_rule.priority
    direction                  = var.network.security_rule.direction
    access                     = var.network.security_rule.access
    protocol                   = var.network.security_rule.protocol
    source_port_range          = var.network.security_rule.source_port_range
    destination_port_range     = var.network.security_rule.destination_port_range
    source_address_prefix      = var.network.security_rule.source_address_prefix
    destination_address_prefix = var.network.security_rule.destination_address_prefix
  }

  tags     = var.tags
}

resource "azurerm_subnet_network_security_group_association" "security_group_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}