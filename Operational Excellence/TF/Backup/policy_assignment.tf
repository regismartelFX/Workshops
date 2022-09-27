data "azurerm_subscription" "sandbox" {
  provider = azurerm.sandbox
}


/*
Modules naming: <Policy name>[_<region code>]_<scope abbreviation>[_<environment code>]
*/

module "Configure_backup_on_virtual_machines_with_a_given_tag_to_an_existing_recovery_services_vault_in_the_same_location_cc_sbx_d" {
  source = "./modules/policy_assignment/Configure_backup_on_virtual_machines_with_a_given_tag_to_an_existing_recovery_services_vault_in_the_same_location/"
  providers = {
    azurerm = azurerm.sandbox
  }

  subscription = {
    id   = data.azurerm_subscription.sandbox.id
    name = data.azurerm_subscription.sandbox.display_name
  }
  not_scopes        = []
  description       = "Enforce backup for all virtual machines by backing them up to an existing central recovery services vault in the same location and subscription as the virtual machine. Doing this is useful when there is a central team in your organization managing backups for all resources in a subscription. You can optionally include virtual machines containing a specified tag to control the scope of assignment. See https://aka.ms/AzureVMCentralBackupIncludeTag."
  location          = module.info.primary_region.name
  vaultLocation     = module.info.primary_region.name
  backupPolicyId    = azurerm_backup_policy_vm.backup_daily.id
  inclusionTagValue = ["${azurerm_backup_policy_vm.backup_daily.name}"]
  depends_on = [
    data.azurerm_subscription.sandbox,
    azurerm_backup_policy_vm.backup_daily
  ]
}
