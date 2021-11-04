resource "azurerm_resource_group" "rg-test-cc" {
  location = var.location
  name     = "rg-hri-testing-cc"
}
resource "azurerm_app_service_plan" "asp-hri-command-api" {
  location                     = azurerm_resource_group.rg-test-cc.location
  name                         = "asp-command-api"
  resource_group_name          = azurerm_resource_group.rg-test-cc.name
  is_xenon                     = false
  kind                         = "linux"
  maximum_elastic_worker_count = 1
  per_site_scaling             = false
  reserved                     = true
  sku {
    capacity = 1
    size     = "P1v2"
    tier     = "PremiumV2"
  }
  tags = {
    "Region" : "Europe"
    "Service" : "CommandCentre"
  }
}

resource "azurerm_app_service" "app-command-api" {
  app_service_plan_id = azurerm_app_service_plan.asp-hri-command-api.id
  location            = azurerm_resource_group.rg-test-cc.location
  name                = "app-command-api"
  resource_group_name = azurerm_resource_group.rg-test-cc.name
}

resource "azurerm_app_service_slot" "staging" {
  app_service_name    = azurerm_app_service.app-command-api.name
  app_service_plan_id = azurerm_app_service_plan.asp-hri-command-api.id
  location            = azurerm_resource_group.rg-test-cc.location
  name                = "staging"
  resource_group_name = azurerm_resource_group.rg-test-cc.name
}

resource "azurerm_app_service" "app-command-srv" {
  name                = "app-command-srv"
  app_service_plan_id = azurerm_app_service_plan.asp-hri-command-api.id
  location            = azurerm_resource_group.rg-test-cc.location
  resource_group_name = azurerm_resource_group.rg-test-cc.name

}

resource "azurerm_sql_server" "hri-stg-command-centre-sr" {
  administrator_login          = "outt"
  administrator_login_password = "T44qEuC5WVhWragM"
  location                     = azurerm_resource_group.rg-test-cc.location
  name                         = "hri-stg-command-centre-db"
  resource_group_name          = azurerm_resource_group.rg-test-cc.name
  version                      = "12.0"
}
resource "azurerm_sql_database" "hri-stg-command-centre-db" {
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  edition             = "Standard"
  read_scale          = false
  location            = azurerm_resource_group.rg-test-cc.location
  name                = "hri-stg-command-centre-db"
  resource_group_name = azurerm_resource_group.rg-test-cc.name
  server_name         = azurerm_sql_server.hri-stg-command-centre-sr.name
}

# resource "azurerm_app_service_virtual_network_swift_connection" "command-centre-vnet" {
#   app_service_id = azurerm_app_service.app-command-api.id
#   subnet_id      = azurerm_subnet.front_end.id
  
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "app-command-srv-vnet" {
#   app_service_id = azurerm_app_service.app-command-srv.id
#   subnet_id      = azurerm_subnet.front_end.id
# }

resource "azurerm_private_endpoint" "web-app-api-endpoint" {
  name = "app-command-api-endpoint"
  location = azurerm_resource_group.rg-test-cc.location
  resource_group_name = azurerm_resource_group.rg-test-cc.name
  subnet_id = azurerm_subnet.front_end.id
  private_service_connection {
    name = "app-command-api-psc"
    private_connection_resource_id = azurerm_app_service.app-command-api.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }

}
# private DNS
resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg-test-cc.name
}

#private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "app-command-api-dnslink"
  resource_group_name   = azurerm_resource_group.rg-test-cc.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.demo-vnet.id
  registration_enabled = false
}
