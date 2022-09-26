data "azurerm_subscription" "sandbox" {
  subscription_id = "88fa2133-05ce-4034-b30f-5a47e7240156"
}


data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "core" {
  provider = azurerm.sandbox

  name     = "rg-${module.info.descriptive_context}-${module.info.sandbox.short_name}01"
  location = module.info.primary_region.name
}


resource "azurerm_key_vault" "core" {
  provider = azurerm.sandbox

  name                            = "kv${module.info.descriptive_context}${module.info.primary_region.code}${module.info.sandbox.short_name}kn7s0"
  location                        = module.info.primary_region.name
  resource_group_name             = azurerm_resource_group.core.name
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
      "List",
      "Get",
    ]

    secret_permissions = [
      "List",
      "Get",
      "Set"
    ]

    certificate_permissions = [
      "List",
      "Get",
    ]
  }
}


resource "azurerm_key_vault_secret" "admin" {
  provider = azurerm.sandbox

  name         = "default-vm-admin-account-name"
  value        = "Demo"
  content_type = "Account name"
  key_vault_id = azurerm_key_vault.core.id
}


resource "azurerm_key_vault_secret" "adminpwd" {
  provider = azurerm.sandbox

  name         = "default-vm-password"
  value        = "Change this value manually in the portal."
  content_type = "Password"
  key_vault_id = azurerm_key_vault.core.id

  lifecycle {
    ignore_changes = [value]
  }
}


resource "azurerm_virtual_network" "core" {
  provider = azurerm.sandbox

  name                = "vnet-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  address_space       = ["192.168.0.0/16"]
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
}


resource "azurerm_subnet" "vmsubnet" {
  provider = azurerm.sandbox

  name                                      = "snet-${module.info.descriptive_context}"
  resource_group_name                       = azurerm_resource_group.core.name
  virtual_network_name                      = azurerm_virtual_network.core.name
  address_prefixes                          = ["192.168.128.0/24"]
  private_endpoint_network_policies_enabled = false
}


# resource "azurerm_storage_account" "sadiag" {
#   provider = azurerm.sandbox

#   name                     = "sadiagintactdemodr54da"
#   resource_group_name      = azurerm_resource_group.demo.name
#   location                 = module.info.primary_region.name
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   min_tls_version          = "TLS1_2"
# }


resource "azurerm_log_analytics_workspace" "core" {
  provider = azurerm.sandbox

  name                = "log-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_automation_account" "core" {
  provider = azurerm.sandbox

  name                = "aa-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_role_assignment" "contributor" {
  provider = azurerm.sandbox

  scope                = data.azurerm_subscription.sandbox.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.core.identity[0].principal_id
}