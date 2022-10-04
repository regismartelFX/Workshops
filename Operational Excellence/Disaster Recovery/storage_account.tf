resource "azurerm_storage_account" "dr" {
  provider = azurerm.sandbox

  name                     = "st${module.info.descriptive_context}asrcache${module.info.primary_region.code}${module.info.sandbox.short_name}72vvs"
  resource_group_name      = data.terraform_remote_state.core.outputs.core_resource_group_name
  location                 = module.info.primary_region.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  #https://learn.microsoft.com/en-us/azure/site-recovery/azure-to-azure-support-matrix#cache-storage
  #Soft delete is not supported because once it is enabled on cache storage account, it increases cost.
}