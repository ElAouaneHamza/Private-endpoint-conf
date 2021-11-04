resource "azurerm_resource_group" "rg-testing-env" {
  location = var.location
  name     = "rg-testing-apim"
}

resource "azurerm_api_management" "demo-apim" {
  name     = "demo-apim-test"
  sku_name = "Developer_1"

  hostname_configuration {
    proxy {
      host_name                    = "apim.test.com"
      certificate                  = filebase64(var.pfx_certificate)
      certificate_password         = var.ssl_certificate_password
      default_ssl_binding          = true
      negotiate_client_certificate = false
    }
  }

  // ... other properties
  location            = var.location
  publisher_email     = "XXXXXX"
  publisher_name      = "XXXXX"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_api_management_api" "demo-users-api" {
  name                = "Configurations"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
  api_management_name = azurerm_api_management.demo-apim.name
  revision            = "1"
  display_name        = "Configuration"
  path                = "configuration"
  protocols           = ["https"]
  # service_url         = "https://backend.mydomain.com/api/v1/users"
}

resource "azurerm_api_management_backend" "command-test-api" {
  name = "command-backend"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
  api_management_name = azurerm_api_management.demo-apim.name
  protocol = "http"
  url = "XXX" # Set web app url
}

resource "azurerm_api_management_api_operation" "Configurations-post" {
  method       = "POST"
  url_template = "/*"
  // ... other properties
  api_management_name = azurerm_api_management.demo-apim.name
  api_name            = azurerm_api_management_api.demo-users-api.name
  display_name        = "configurations_POST"
  operation_id        = "POST"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_api_management_api_operation" "Configurations-delete" {
  method       = "DELETE"
  url_template = "/*"
  // ... other properties
  api_management_name = azurerm_api_management.demo-apim.name
  api_name            = azurerm_api_management_api.demo-users-api.name
  display_name        = "configurations_DELETE"
  operation_id        = "DELETE"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_api_management_api_operation" "Configurations-get" {
  method       = "GET"
  url_template = "/*"
  // ... other properties
  api_management_name = azurerm_api_management.demo-apim.name
  api_name            = azurerm_api_management_api.demo-users-api.name
  display_name        = "configurations_GET"
  operation_id        = "GET"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_api_management_api_operation" "Configurations-opt" {
  method       = "OPTIONS"
  url_template = "/*"
  // ... other properties
  api_management_name = azurerm_api_management.demo-apim.name
  api_name            = azurerm_api_management_api.demo-users-api.name
  display_name        = "configurations_OPT"
  operation_id        = "OPT"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}

resource "azurerm_api_management_api_operation" "Configurations-put" {
  method       = "PUT"
  url_template = "/*"
  // ... other properties
  api_management_name = azurerm_api_management.demo-apim.name
  api_name            = azurerm_api_management_api.demo-users-api.name
  display_name        = "configurations_PUT"
  operation_id        = "PUT"
  resource_group_name = azurerm_resource_group.rg-testing-env.name
}
