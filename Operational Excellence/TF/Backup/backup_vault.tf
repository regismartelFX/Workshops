resource "azurerm_data_protection_backup_vault" "backup" {
  provider = azurerm.sandbox

  name                = "bv-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  location            = module.info.primary_region.name
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_role_assignment" "backup_vault_storage_account_backup_contributor" {
  provider = azurerm.sandbox

  scope                = data.terraform_remote_state.vm.outputs.stdiag_storage_account_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.backup.identity[0].principal_id
}


resource "azurerm_data_protection_backup_policy_blob_storage" "backup" {
  provider = azurerm.sandbox

  name               = "DEMO-35d"
  vault_id           = azurerm_data_protection_backup_vault.backup.id
  retention_duration = "P35D"
}


resource "azurerm_data_protection_backup_instance_blob_storage" "backup" {
  provider = azurerm.sandbox

  name               = "backup-${module.info.descriptive_context}-sadiag"
  vault_id           = azurerm_data_protection_backup_vault.backup.id
  location           = module.info.primary_region.name
  storage_account_id = data.terraform_remote_state.vm.outputs.stdiag_storage_account_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.backup.id

  depends_on = [azurerm_role_assignment.backup_vault_storage_account_backup_contributor]
}