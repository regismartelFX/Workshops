resource "azurerm_storage_account" "stdiag" {
  provider = azurerm.sandbox

  name                     = "stdiag${module.info.descriptive_context}${module.info.primary_region.code}${module.info.sandbox.short_name}6r5da"
  resource_group_name      = data.terraform_remote_state.core.outputs.core_resource_group_name
  location                 = module.info.primary_region.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}
