resource "azurerm_log_analytics_solution" "changetracking" {
  provider = azurerm.sandbox

  solution_name         = "ChangeTracking"
  location              = module.info.primary_region.name
  resource_group_name   = data.terraform_remote_state.core.outputs.core_resource_group_name
  workspace_resource_id = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
  workspace_name        = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}
