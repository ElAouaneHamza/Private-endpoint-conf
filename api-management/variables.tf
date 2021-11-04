data "azurerm_client_config" "current" {}

variable "location" {
  default = "westeurope"
}

provider "azurerm" {
  features {}
}

variable "ssl_certificate_path" {
  default = "certificate.cer"
}

variable "pfx_certificate" {
  default = "certificate.pfx"

}

variable "ssl_certificate_password" {
  default = ""
}

variable "hub" {
  type        = string
  description = "Used for both the vnet and the resource group, and to prefix resources."
  default     = "hub"
}

variable "vpn_client" {
  description = "Boolean to control creation of vpn_client_configuration block."
  type        = bool
  default     = false
}

variable "vpn_client_address_space" {
  description = "List of address spaces for the vpn client."
  type        = list(string)
  default     = ["192.168.76.0/24"]
}

variable "vpn_client_cert" {
  description = "Base 64 encoded X.509 PEM cert."
  type        = string
  default     = "./base64_x509_caCert.pem"
}

variable "vpn_client_cert_name" {
  description = "Description for the root cert."
  type        = string
  default     = "SelfSignedCertificate"
}