resource "azurerm_data_protection_backup_vault" "demo" {
  provider = azurerm.demo_1

  name                = "bv-demo-cc-p01"
  resource_group_name = data.azurerm_resource_group.demo.name
  location            = module.info.primary_region.name
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_role_assignment" "sadiag" {
  provider = azurerm.demo_1

  scope                = data.azurerm_storage_account.sadiag.id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.demo.identity[0].principal_id
}


resource "azurerm_data_protection_backup_policy_blob_storage" "demo" {
  provider = azurerm.demo_1

  name               = "DEMO-35d"
  vault_id           = azurerm_data_protection_backup_vault.demo.id
  retention_duration = "P35D"
}


resource "azurerm_data_protection_backup_instance_blob_storage" "demo" {
  provider = azurerm.demo_1

  name               = "demo-backup-sadiag"
  vault_id           = azurerm_data_protection_backup_vault.demo.id
  location           = module.info.primary_region.name
  storage_account_id = data.azurerm_storage_account.sadiag.id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.demo.id

  depends_on = [azurerm_role_assignment.sadiag]
}