provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-from-pipeline-99"
  location = "japaneast"
}
