resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/network"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  network             = var.network

  tags = var.tags
}

module "compute" {
  source = "./modules/compute"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  compute               = var.compute
  network_interfaces    = module.network.network_interfaces

  tags = var.tags
}