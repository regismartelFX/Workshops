resource "azurerm_monitor_activity_log_alert" "servicehealth" {
  provider = azurerm.sandbox

  name                = "Monitor Azure Service Health ${module.info.descriptive_context}"
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  scopes              = [data.azurerm_subscription.sandbox.id]
  description         = "Monitor Azure Service Health"
  enabled             = true

  criteria {
    category = "ServiceHealth"

    service_health {
      events    = null #null = all events
      locations = ["global", module.info.primary_region.name, module.info.secondary_region.name]
      services  = null #null = all services
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.monlog.id
  }
}