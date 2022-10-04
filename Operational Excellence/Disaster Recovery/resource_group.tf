resource "azurerm_resource_group" "dr" {
  provider = azurerm.sandbox

  name     = "rg-${module.info.descriptive_context}asr-${module.info.sandbox.short_name}01"
  location = module.info.secondary_region.name
}