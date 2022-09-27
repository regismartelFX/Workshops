/*
Data sources used in conjonction with a depends_on clause in the module to validate
 that every resource needed to apply the policies exists prior to the policies being deployed.
*/
# data "azurerm_subscription" "demo" {
#   provider = azurerm.sandbox

#   subscription_id = "bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
# }

data "azurerm_subscription" "sandbox" {
  provider = azurerm.sandbox

  #  subscription_id = "bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
}

# data "azurerm_client_config" "sandbox" {
#    provider = azurerm.sandbox
# }


# data "azurerm_backup_policy_vm" "demo_daily" {
#   provider = azurerm.sandbox

#   name                = "DEMO-35d-12m-7y"
#   recovery_vault_name = "rsv-intactoperationalexcellencecc-p01"
#   resource_group_name = "rg-intactoperationalexcellence-p01"
# }


/*
Modules naming: <Policy name>[_<region code>]_<scope abbreviation>[_<environment code>]
*/

# module "Configure_backup_on_virtual_machines_with_a_given_tag_to_an_existing_recovery_services_vault_in_the_same_location_cc_DEMO_d" {
#   source = "./modules/policy_assignment/Configure_backup_on_virtual_machines_with_a_given_tag_to_an_existing_recovery_services_vault_in_the_same_location/"

#   subscription = {
#     id   = data.azurerm_subscription.sandbox.id
#     name = data.azurerm_subscription.sandbox.display_name
#   }
#   not_scopes        = []
#   description       = "Enforce backup for all virtual machines by backing them up to an existing central recovery services vault in the same location and subscription as the virtual machine. Doing this is useful when there is a central team in your organization managing backups for all resources in a subscription. You can optionally include virtual machines containing a specified tag to control the scope of assignment. See https://aka.ms/AzureVMCentralBackupIncludeTag."
#   location          = module.info.primary_region.name
#   vaultLocation     = module.info.primary_region.name
#   backupPolicyId    = azurerm_backup_policy_vm.demo_daily.id
#   inclusionTagValue = ["${azurerm_backup_policy_vm.demo_daily.name}"]
#   depends_on = [
#     data.azurerm_subscription.sandbox,
#     #data.azurerm_backup_policy_vm.demo_daily
#   ]
# }

output "id" {

  value = data.azurerm_subscription.sandbox.id
}


output "name" {

  value = data.azurerm_subscription.sandbox.display_name
}