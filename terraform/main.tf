provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-from-pipeline"
  location = "japaneast"
}

