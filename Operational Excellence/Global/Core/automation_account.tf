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