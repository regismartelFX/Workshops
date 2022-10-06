resource "azurerm_key_vault" "core" {
  provider = azurerm.sandbox

  name                            = "kv${module.info.descriptive_context}${module.info.primary_region.code}${module.info.sandbox.short_name}${module.info.core_key_vault_unique}"
  location                        = module.info.primary_region.name
  resource_group_name             = azurerm_resource_group.core.name
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_subscription.sandbox.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_subscription.sandbox.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "List",
      "Get",
    ]

    secret_permissions = [
      "List",
      "Get",
      "Set"
    ]

    certificate_permissions = [
      "List",
      "Get",
    ]
  }
}


resource "azurerm_key_vault_secret" "admin" {
  provider = azurerm.sandbox

  name         = "default-vm-admin-account-name"
  value        = module.info.default_vm_admin_account_name
  content_type = "Account name"
  key_vault_id = azurerm_key_vault.core.id
}


resource "azurerm_key_vault_secret" "adminpwd" {
  provider = azurerm.sandbox

  name         = "default-vm-password"
  value        = "Change this value manually in the portal."
  content_type = "Password"
  key_vault_id = azurerm_key_vault.core.id

  lifecycle {
    ignore_changes = [value]
  }
}
