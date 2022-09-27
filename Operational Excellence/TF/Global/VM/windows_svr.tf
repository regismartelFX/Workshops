module "windows_svr" {
  source = "./modules/windows_virtual_machine"
  providers = {
    azurerm = azurerm.sandbox
  }

  quantity                            = 2
  seed                                = 1
  descriptive_context                 = "${module.info.descriptive_context}svr"
  environment                         = module.info.sandbox.short_name
  location                            = module.info.primary_region.name
  stdiag_resource_group_name          = data.terraform_remote_state.core.outputs.core_resource_group_name
  stdiag_name                         = azurerm_storage_account.stdiag.name
  core_resource_group_name            = data.terraform_remote_state.core.outputs.core_resource_group_name
  core_key_vault_name                 = data.terraform_remote_state.core.outputs.core_key_vault_name
  core_key_vault_admin_secret_name    = "default-vm-admin-account-name"
  core_key_vault_adminpwd_secret_name = "default-vm-password"
  core_virtual_network_name           = data.terraform_remote_state.core.outputs.core_virtual_network_name
  core_subnet_name                    = data.terraform_remote_state.core.outputs.core_subnet_name
  core_log_analytics_workspace_name   = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_name
  size                                = module.info.windows_svr_size
  source_image_reference              = module.info.windows_svr_source_image_reference
  tags = {
    BackupPolicy   = ["DEMO-35d-12m-7y"]
    PatchingPolicy = ["Windows Group A", "Windows Group B"]
  }

  depends_on = [
    azurerm_storage_account.stdiag
  ]
}
