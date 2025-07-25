resource "azurerm_subnet" "example_subnet" {
  name                 = "subnet-from-pipeline-99"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
