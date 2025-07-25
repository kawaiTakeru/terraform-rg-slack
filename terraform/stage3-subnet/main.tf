data "azurerm_resource_group" "example" {
  name = "rg-from-pipeline"
}

data "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-from-pipeline"
  resource_group_name = data.azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "subnet-from-pipeline"
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = data.azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
