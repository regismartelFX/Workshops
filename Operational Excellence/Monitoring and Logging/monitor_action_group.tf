resource "azurerm_monitor_action_group" "monlog" {
  provider = azurerm.sandbox

  name                = "ag-${module.info.descriptive_context}"
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  short_name          = module.info.descriptive_context

  email_receiver {
    name                    = module.info.email_receiver_name
    email_address           = module.info.email_receiver_email_address
    use_common_alert_schema = true
  }
}