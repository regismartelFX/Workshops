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

  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  workspace_id        = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
  read_access_id      = data.terraform_remote_state.core.outputs.core_automation_account_id
}