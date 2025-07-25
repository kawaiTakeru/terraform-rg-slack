provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "rg-from-pipeline"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-from-pipeline"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}

