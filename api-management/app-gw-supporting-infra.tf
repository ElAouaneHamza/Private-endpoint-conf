resource "azurerm_network_security_group" "demo-app-gateway-nsg" {
  name = "demo-app-gateway-nsg"

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "65200-65535"
    direction                  = "Inbound"
    name                       = "AllowBackendHealthPortsInBound"
    priority                   = 100
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    direction                  = "Inbound"
    name                       = "AllowApiManagerHttpsInBound"
    priority                   = 110
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hri-testing-env.name
}

resource "azurerm_subnet" "demo-app-gateway-subnet" {
  address_prefixes     = ["10.100.0.128/27"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  name                 = "demo-gateway-subnet"
  resource_group_name  = azurerm_resource_group.rg-hri-testing-env.name
}

resource "azurerm_public_ip" "demo-app-gateway-public-ip" {
  name                = "demo-app-gateway"
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "demo-app-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hri-testing-env.name
}