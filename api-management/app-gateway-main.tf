
resource "azurerm_application_gateway" "demo-app-gateway" {
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hri-testing-env.name
  name                = "demo-app-gateway"

  autoscale_configuration {
    max_capacity = 10
    min_capacity = 2
  }

  frontend_port {
    name = "port_443"
    port = 443
  }

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  frontend_ip_configuration {
    name                          = "appGwPublicFrontendIp"
    public_ip_address_id          = azurerm_public_ip.demo-app-gateway-public-ip.id
    private_ip_address_allocation = "Dynamic"
  }

  backend_http_settings {
    cookie_based_affinity               = "Disabled"
    name                                = "demo-http-settings"
    port                                = 443
    protocol                            = "Https"
    host_name                           = "apim.test.com"
    pick_host_name_from_backend_address = false
    path                                = "/external/"
    request_timeout                     = 20
    probe_name                          = "demo-apim-probe"
    trusted_root_certificate_names      = ["demo-trusted-root-ca-certificate"]
  }

  probe {
    interval                                  = 30
    name                                      = "demo-apim-probe"
    path                                      = "/status-0123456789abcdef"
    protocol                                  = "Https"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match {
      body = ""
      status_code = [
        "200-399"
      ]
    }
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.ApplicationGate.id
  }

  backend_address_pool {
    name = "demo-backend-pool"
  }

  http_listener {
    frontend_ip_configuration_name = "appGwPublicFrontendIp"
    frontend_port_name             = "port_443"
    name                           = "demo-app-gateway-listener"
    protocol                       = "Https"
    require_sni                    = false
    ssl_certificate_name           = "demo-app-gateway-certificate"
  }

  ssl_certificate {
    data     = filebase64(var.pfx_certificate)
    name     = "demo-app-gateway-certificate"
    password = var.ssl_certificate_password


  }

  trusted_root_certificate {
    data = filebase64(var.ssl_certificate_path)
    name = "demo-trusted-root-ca-certificate"
  }

  request_routing_rule {
    http_listener_name         = "demo-app-gateway-listener"
    name                       = "demo-rule"
    rule_type                  = "Basic"
    backend_address_pool_name  = "demo-backend-pool"
    backend_http_settings_name = "demo-http-settings"
  }
}
