resource "azurerm_resource_group" "core" {
  provider = azurerm.sandbox

  name     = "rg-${module.info.descriptive_context}-${module.info.sandbox.short_name}01"
  location = module.info.primary_region.name
}