data "azurerm_subscription" "sandbox" {
  provider = azurerm.sandbox
}


data "azurerm_client_config" "current" {}