data "azurerm_subscription" "demo_1" {
  subscription_id = "bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
}


data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "demo" {
  provider = azurerm.demo_1

  name     = "rg-intactoperationalexcellence-p01"
  location = module.info.primary_region.name
}


resource "azurerm_key_vault" "demo" {
  provider = azurerm.demo_1

  name                            = "kvdemoccpkn7s0"
  location                        = module.info.primary_region.name
  resource_group_name             = azurerm_resource_group.demo.name
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


resource "azurerm_key_vault_secret" "admin" {
  provider = azurerm.demo_1

  name         = "default-vm-admin-account-name"
  value        = "Demo"
  content_type = "Account name"
  key_vault_id = azurerm_key_vault.demo.id
}


resource "azurerm_key_vault_secret" "adminpwd" {
  provider = azurerm.demo_1

  name         = "default-vm-password"
  value        = "Change this value manually in the portal."
  content_type = "Password"
  key_vault_id = azurerm_key_vault.demo.id
}


resource "azurerm_virtual_network" "demo" {
  provider = azurerm.demo_1

  name                = "vnet-intactoperationalexcellence-p01"
  address_space       = ["192.168.0.0/16"]
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.demo.name
}


resource "azurerm_subnet" "vmsubnet" {
  provider = azurerm.demo_1

  name                                      = "snet-intact"
  resource_group_name                       = azurerm_resource_group.demo.name
  virtual_network_name                      = azurerm_virtual_network.demo.name
  address_prefixes                          = ["192.168.128.0/24"]
  private_endpoint_network_policies_enabled = false
}


resource "azurerm_storage_account" "sadiag" {
  provider = azurerm.demo_1

  name                     = "sadiagintactdemodr54da"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = module.info.primary_region.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}


resource "azurerm_log_analytics_workspace" "demo" {
  provider = azurerm.demo_1

  name                = "log-demo-p01"
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_automation_account" "demo" {
  provider = azurerm.demo_1

  name                = "aa-dsc-cc-p01"
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.demo.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_role_assignment" "contributor" {
  provider = azurerm.demo_1

  scope                = data.azurerm_subscription.demo_1.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.demo.identity[0].principal_id
}