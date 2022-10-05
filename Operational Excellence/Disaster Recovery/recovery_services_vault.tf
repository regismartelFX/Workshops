resource "azurerm_recovery_services_vault" "dr" {
  provider = azurerm.sandbox

  name                = "rsv-${module.info.descriptive_context}asr-${module.info.secondary_region.code}-${module.info.sandbox.short_name}01"
  resource_group_name = azurerm_resource_group.dr.name
  location            = module.info.secondary_region.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
  soft_delete_enabled = true

  lifecycle {
    ignore_changes = [tags]
  }
}
