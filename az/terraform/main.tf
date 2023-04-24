resource "azurerm_resource_group" "example" {
  for_each = var.resource_groups

  name     = each.value.name
  location = var.location
}

module "network" {
  source = "./modules/network"

  network             = var.network
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = var.tags
}

module "compute" {
  source = "./modules/compute"

  compute             = var.compute
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  network_interface_ids = [module.network.network_interface_id]

  tags = var.tags
}