resource "azurerm_storage_account" "core" {
  provider = azurerm.sandbox

  name                     = "st${module.info.descriptive_context}${module.info.primary_region.code}${module.info.sandbox.short_name}${module.info.core_storage_account_random}"
  resource_group_name      = azurerm_resource_group.core.name
  location                 = module.info.primary_region.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}