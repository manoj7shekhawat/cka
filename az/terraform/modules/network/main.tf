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