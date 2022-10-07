resource "azurerm_log_analytics_workspace" "core" {
  provider = azurerm.sandbox

  name                = "log-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_log_analytics_linked_service" "core" {
  provider = azurerm.sandbox

  resource_group_name = azurerm_resource_group.core.name
  workspace_id        = azurerm_log_analytics_workspace.core.id
  read_access_id      = azurerm_automation_account.core.id
}