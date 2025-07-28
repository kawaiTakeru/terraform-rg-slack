# デフォルト: Spoke側
provider "azurerm" {
  features {}
}

# alias: Hub側（別subscription）
provider "azurerm" {
  alias           = "hub"
  subscription_id = "HUB側のサブスクリプションID"
  features        = {}
}

# Spoke側のVNet（自分のサブスクリプション）
data "azurerm_virtual_network" "spoke" {
  name                = "vnet-from-pipeline"
  resource_group_name = "rg-from-pipeline"
  subscription_id     = "Spoke側のサブスクリプションID"
}

# Hub → Spoke のピアリングをHub側に設定
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                  = azurerm.hub
  name                      = "hub-to-spoke"
  resource_group_name       = "rg-test-hubnw-prd-jpe-001"
  virtual_network_name      = "vnet-test-hubnw-prd-jpe-001"
  remote_virtual_network_id = data.azurerm_virtual_network.spoke.id

  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = false
}
