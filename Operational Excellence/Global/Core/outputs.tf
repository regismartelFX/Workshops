output "core_resource_group_name" {

  value = azurerm_resource_group.core.name
}


output "core_key_vault_name" {

  value = azurerm_key_vault.core.name
}


output "core_virtual_network_name" {

  value = azurerm_virtual_network.core.name
}


output "core_subnet_name" {

  value = azurerm_subnet.core.name
}


output "core_log_analytics_workspace_name" {

  value = azurerm_log_analytics_workspace.core.name
}


output "core_log_analytics_workspace_id" {

  value = azurerm_log_analytics_workspace.core.id
}


output "core_automation_account_name" {

  value = azurerm_automation_account.core.name
}


output "core_automation_account_id" {

  value = azurerm_automation_account.core.id
}