module "workstation" {
  source = "./modules/windows_virtual_machine"

  quantity                            = 2
  seed                                = 3
  descriptive_context                 = "demo"
  environment                         = "t"
  location                            = module.info.primary_region.name
  core_resource_group_name            = "rg-intactoperationalexcellence-p01"
  core_key_vault_name                 = "kvdemoccpkn7s0"
  core_key_vault_admin_secret_name    = "default-vm-admin-account-name"
  core_key_vault_adminpwd_secret_name = "default-vm-password"
  core_virtual_network_name           = "vnet-intactoperationalexcellence-p01"
  core_subnet_name                    = "snet-intact"
  core_log_analytics_workspace_name   = "log-demo-p01"
  windows_virtual_machine_size        = "Standard_B2ms"
  source_image_reference = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }
}