# module "linux" {
#   source = "./modules/linux_virtual_machine"

#   quantity                            = 2
#   seed                                = 1
#   descriptive_context                 = "demo"
#   environment                         = "t"
#   location                            = module.info.primary_region.name
#   stdiag_name                         = stdiag.name
#   core_resource_group_name            = "rg-intactoperationalexcellence-p01"
#   core_key_vault_name                 = "kvdemoccpkn7s0"
#   core_key_vault_admin_secret_name    = "default-vm-admin-account-name"
#   core_key_vault_adminpwd_secret_name = "default-vm-password"
#   core_virtual_network_name           = "vnet-intactoperationalexcellence-p01"
#   core_subnet_name                    = "snet-intact"
#   core_log_analytics_workspace_name   = "log-demo-p01"
#   size                                = "Standard_B4ms"
#   source_image_reference              = module.info.windows_svr_source_image_reference
#   tags = {
#     BackupPolicy   = "DEMO-35d-12m-7y"
#     PatchingPolicy = "Linux Group A"
#   }
# }
