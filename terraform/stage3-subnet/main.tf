provider "azurerm" {
  features {}
}

# リソースグループの参照
data "azurerm_resource_group" "example" {
  name = "rg-from-pipeline"
}

# VNetの参照
data "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-from-pipeline"
  resource_group_name = data.azurerm_resource_group.example.name
}

# Network Security Group（VPNクライアントからの接続のみ許可）
resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private-subnet"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name                       = "Allow-VPN-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389" # RDP。SSHなら 22 に変えてOK
    source_address_prefix      = "172.16.201.0/24" # VPNクライアントアドレスプールに合わせる
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Internet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# サブネット（Private用途）
resource "azurerm_subnet" "example_subnet" {
  name                 = "subnet-from-pipeline"
  resource_group_name  = data.azurerm_resource_group.example.name
  virtual_network_name = data.azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# サブネットとNSGの関連付け
resource "azurerm_subnet_network_security_group_association" "example_assoc" {
  subnet_id                 = azurerm_subnet.example_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
