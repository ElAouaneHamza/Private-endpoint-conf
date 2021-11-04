resource "azurerm_virtual_network" "demo-vnet" {
  name                = "virtual-network-test"
  address_space       = ["10.100.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hri-testing-env.name
}

resource "azurerm_network_security_group" "demo-apim-nsg" {
  name = "apim-nsg"

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "AzureActiveDirectory"
    destination_port_ranges    = ["443", "80"]
    direction                  = "Outbound"
    name                       = "AllowAzureActiveDirectoryOutBound"
    priority                   = 100
    protocol                   = "TCP"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges    = ["443", "80"]
    direction                  = "Inbound"
    name                       = "AllowClientCommunicationToApiInBound"
    priority                   = 100
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "3443"
    direction                  = "Inbound"
    name                       = "AllowApiManagementInBound"
    priority                   = 110
    protocol                   = "TCP"
    source_address_prefix      = "ApiManagement"
    source_port_range          = "*"
  }
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "demo-apim-subnet" {
  name                 = "apim-subnets"
  address_prefixes     = ["10.100.0.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  //  network_security_group_id = azurerm_network_security_group.demo-apim-nsg.id
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "SharedServices" {
  name                 = "SharedServices"
  address_prefixes     = ["10.100.1.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  //  network_security_group_id = azurerm_network_security_group.demo-apim-nsg.id
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "DomainController" {
  name                 = "DomainController"
  address_prefixes     = ["10.100.2.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  //  network_security_group_id = azurerm_network_security_group.demo-apim-nsg.id
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "GatewaSubnet" {
  name                 = "GatewaySubnet"
  address_prefixes     = ["10.100.3.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  //  network_security_group_id = azurerm_network_security_group.demo-apim-nsg.id
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "ApplicationGate" {
  name                 = "ApplicationGate"
  address_prefixes     = ["10.100.4.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  //  network_security_group_id = azurerm_network_security_group.demo-apim-nsg.id
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_subnet" "front_end" {
  name                 = "Front_End-Subnet"
  address_prefixes     = ["10.100.5.0/28"]
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  resource_group_name  = azurerm_resource_group.rg-testing-env.name
  enforce_private_link_service_network_policies = true
}

resource "azurerm_private_dns_zone" "demo-private-dns-zone" {
  name                = "demoprivate.local.com"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "demo-private-dns-zone-vnet-link" {
  name                  = "demo-private-dns-zone-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.demo-private-dns-zone.name
  //  virtual_network_name  = azurerm_virtual_network.demo-vnet.name
  resource_group_name = azurerm_resource_group.rg-testing-env.name
  virtual_network_id  = azurerm_virtual_network.demo-vnet.id
}

output "vnet" {
  value = azurerm_virtual_network.demo-vnet
}

output "subnet" {
  value = {
    "SharedServices"    = azurerm_subnet.SharedServices
    "DomainControllers" = azurerm_subnet.DomainController
    "GatewaySubnet"     = azurerm_subnet.GatewaSubnet
  }
}