resource "azurerm_monitor_diagnostic_setting" "sandbox" {
  provider = azurerm.sandbox

  name                       = "activitylogdiag"
  target_resource_id         = data.azurerm_subscription.sandbox.id
  storage_account_id         = data.terraform_remote_state.core.outputs.core_storage_account_id
  log_analytics_workspace_id = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id

  dynamic "log" {
    for_each = ["Administrative", "Alert", "Autoscale", "Policy", "Recommendation", "ResourceHealth", "Security", "ServiceHealth"]
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 60
      }
    }
  }
}
