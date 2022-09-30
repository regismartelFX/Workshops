module "Deploy_Diagnostic_Settings_for_Automation_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Automation_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_for_Network_Interfaces_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Network_Interfaces_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_for_Network_Security_Groups_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Network_Security_Groups_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_for_Virtual_Machines_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Virtual_Machines_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_for_Virtual_Machine_Scale_Sets_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Virtual_Machine_Scale_Sets_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_for_Virtual_Network_to_Log_Analytics_workspace" {
  source = "./modules/policy_definition/Deploy_Diagnostic_Settings_for_Virtual_Network_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
}


module "Deploy_Diagnostic_Settings_to_Log_Analytics_workspace_initiative" {
  source = "./modules/policy_set_definition/Deploy_Diagnostic_Settings_to_Log_Analytics_workspace"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group_id = data.azurerm_management_group.root.id
  definition_references = [
    "/providers/Microsoft.Authorization/policyDefinitions/bef3f64c-5290-43b7-85b0-9b254eef4c47", #Deploy Diagnostic Settings for Key Vault to Log Analytics workspace
    module.Deploy_Diagnostic_Settings_for_Automation_to_Log_Analytics_workspace.policy_definition_id,
    module.Deploy_Diagnostic_Settings_for_Network_Interfaces_to_Log_Analytics_workspace.policy_definition_id,
    module.Deploy_Diagnostic_Settings_for_Network_Security_Groups_to_Log_Analytics_workspace.policy_definition_id,
    module.Deploy_Diagnostic_Settings_for_Virtual_Machines_to_Log_Analytics_workspace.policy_definition_id,
    module.Deploy_Diagnostic_Settings_for_Virtual_Machine_Scale_Sets_to_Log_Analytics_workspace.policy_definition_id,
    module.Deploy_Diagnostic_Settings_for_Virtual_Network_to_Log_Analytics_workspace.policy_definition_id,
  ]
}


/*
Modules naming: <Policy name>[_<region code>]_<scope abbreviation>[_<environment code>]
*/

module "Deploy_Diagnostic_Settings_to_Log_Analytics_workspace_cc_root_s" {
  source = "./modules/policy_assignment/Deploy_Diagnostic_Settings_to_Log_Analytics_workspace/"
  providers = {
    azurerm = azurerm.sandbox
  }

  policy_definition_id = module.Deploy_Diagnostic_Settings_to_Log_Analytics_workspace_initiative.policy_set_definition_id
  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes   = []
  description  = "Deploys the diagnostic settings for various resources to stream to a regional Log Analytics workspace when any resource which is missing this diagnostic settings is created or updated."
  location     = module.info.primary_region.name
  logAnalytics = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id

  depends_on = [
    data.azurerm_management_group.root
  ]
}


module "Deploy_Diagnostic_Settings_for_Recovery_Services_Vault_to_Log_Analytics_workspace_for_resource_specific_categories_cc_root_s" {
  source = "./modules/policy_assignment/Deploy_Diagnostic_Settings_for_Recovery_Services_Vault_to_Log_Analytics_workspace/"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes   = []
  description  = "Deploy Diagnostic Settings for Recovery Services Vault to stream to Log Analytics workspace for Resource specific categories. If any of the Resource specific categories are not enabled, a new diagnostic setting is created."
  location     = module.info.primary_region.name
  logAnalytics = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id

  depends_on = [
    data.azurerm_management_group.root
  ]
}


module "Configure_network_security_groups_to_enable_traffic_analytics_cc_root_s" {
  source = "./modules/policy_assignment/Configure_network_security_groups_to_enable_traffic_analytics/"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes          = []
  description         = "Provides visibility into user and application activity in cloud networks."
  location            = "canadacentral" #Hard-coded because of Network watcher
  nsgRegion           = "canadacentral" #Hard-coded because of Network watcher
  storageId           = data.terraform_remote_state.core.outputs.core_storage_account_id
  timeInterval        = "10"
  workspaceResourceId = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
  workspaceRegion     = module.info.primary_region.name
  workspaceId         = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_workspace_id
  networkWatcherRG    = data.azurerm_resource_group.networkwatcher.name
  networkWatcherName  = data.azurerm_network_watcher.networkwatcher_canadacentral.name

  depends_on = [
    data.azurerm_management_group.root,
    data.azurerm_network_watcher.networkwatcher_canadacentral
  ]
}


module "Flow_logs_should_be_configured_and_enabled_for_every_network_security_group_cc_root_s" {
  source = "./modules/policy_assignment/Flow_logs_should_be_configured_and_enabled_for_every_network_security_group/"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes  = []
  description = "Audit for network security groups to verify if flow logs are configured and if flow log status is enabled."

  depends_on = [
    data.azurerm_management_group.root
  ]
}


module "Enable_Azure_Monitor_for_VMs_cc_root_s" {
  source = "./modules/policy_assignment/Enable_Azure_Monitor_for_VMs/"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes     = []
  description    = "Enable Azure Monitor for the virtual machines in ${data.azurerm_management_group.root.name}."
  location       = module.info.primary_region.name
  logAnalytics_1 = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id

  depends_on = [
    data.azurerm_management_group.root
  ]
}


module "Enable_Azure_Monitor_for_Virtual_Machine_Scale_Sets_cc_root_s" {
  source = "./modules/policy_assignment/Enable_Azure_Monitor_for_Virtual_Machine_Scale_Sets/"
  providers = {
    azurerm = azurerm.sandbox
  }

  management_group = {
    id   = data.azurerm_management_group.root.id
    name = data.azurerm_management_group.root.display_name
  }
  not_scopes     = []
  description    = "Enable Azure Monitor for the virtual machines in ${data.azurerm_management_group.root.name}."
  location       = module.info.primary_region.name
  logAnalytics_1 = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id

  depends_on = [
    data.azurerm_management_group.root
  ]
}
