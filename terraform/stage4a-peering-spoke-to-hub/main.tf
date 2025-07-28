provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "spoke" {
  name                = "vnet-from-pipeline"
  resource_group_name = "rg-from-pipeline"
}

data "azurerm_virtual_network" "hub" {
  name                = "vnet-test-hubnw-prd-jpe-001"
  resource_group_name = "rg-test-hubnw-prd-jpe-001"
  subscription_id     = "HUB側のサブスクリプションID"
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = "rg-from-pipeline"
  virtual_network_name      = data.azurerm_virtual_network.spoke.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub.id

  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = false
}
