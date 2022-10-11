resource "azurerm_resource_group" "linux" {
  provider = azurerm.sandbox
  count    = module.info.linux_asr == true ? length(data.terraform_remote_state.vm.outputs.linux) : 0

  name     = data.terraform_remote_state.vm.outputs.linux[count.index].asr_resource_group_name
  location = module.info.secondary_region.name
}


resource "azurerm_site_recovery_replicated_vm" "linux" {
  provider = azurerm.sandbox
  count    = module.info.linux_asr == true ? length(data.terraform_remote_state.vm.outputs.linux) : 0

  name                                      = "${data.terraform_remote_state.vm.outputs.linux[count.index].virtual_machine_name}-asr"
  resource_group_name                       = azurerm_resource_group.dr.name
  recovery_vault_name                       = azurerm_recovery_services_vault.dr.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = data.terraform_remote_state.vm.outputs.linux[count.index].virtual_machine_id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.dr.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = azurerm_resource_group.linux[count.index].id
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = data.terraform_remote_state.vm.outputs.linux_disk[count.index][data.terraform_remote_state.vm.outputs.linux[count.index].virtual_machine_os_disk_name] #lower(data.azurerm_managed_disk.primary_vm_domain_controllers_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
    staging_storage_account_id = azurerm_storage_account.dr.id
    target_resource_group_id   = azurerm_resource_group.linux[count.index].id
    target_disk_type           = data.terraform_remote_state.vm.outputs.linux[count.index].virtual_machine_os_storage_account_type
    target_replica_disk_type   = "Standard_LRS"
  }

  target_network_id = azurerm_virtual_network.dr.id

  network_interface {
    source_network_interface_id = data.terraform_remote_state.vm.outputs.linux[count.index].virtual_machine_network_interface_id
    target_subnet_name          = azurerm_subnet.dr.name
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.dr,
    azurerm_site_recovery_network_mapping.core,
  ]
}


resource "azurerm_resource_group" "windows_svr" {
  provider = azurerm.sandbox
  count    = module.info.windows_svr_asr == true ? length(data.terraform_remote_state.vm.outputs.windows_svr) : 0

  name     = data.terraform_remote_state.vm.outputs.windows_svr[count.index].asr_resource_group_name
  location = module.info.secondary_region.name
}


resource "azurerm_site_recovery_replicated_vm" "windows_svr" {
  provider = azurerm.sandbox
  count    = module.info.windows_svr_asr == true ? length(data.terraform_remote_state.vm.outputs.windows_svr) : 0

  name                                      = "${data.terraform_remote_state.vm.outputs.windows_svr[count.index].virtual_machine_name}-asr"
  resource_group_name                       = azurerm_resource_group.dr.name
  recovery_vault_name                       = azurerm_recovery_services_vault.dr.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = data.terraform_remote_state.vm.outputs.windows_svr[count.index].virtual_machine_id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.dr.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = azurerm_resource_group.windows_svr[count.index].id #data.terraform_remote_state.vm.outputs.windows_svr_rg[count.index][data.terraform_remote_state.vm.outputs.windows_svr[count.index].resource_group_name]
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = data.terraform_remote_state.vm.outputs.windows_svr_disk[count.index][data.terraform_remote_state.vm.outputs.windows_svr[count.index].virtual_machine_os_disk_name] #lower(data.azurerm_managed_disk.primary_vm_domain_controllers_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
    staging_storage_account_id = azurerm_storage_account.dr.id
    target_resource_group_id   = azurerm_resource_group.windows_svr[count.index].id #data.terraform_remote_state.vm.outputs.windows_svr_rg[count.index][data.terraform_remote_state.vm.outputs.windows_svr[count.index].resource_group_name]
    target_disk_type           = data.terraform_remote_state.vm.outputs.windows_svr[count.index].virtual_machine_os_storage_account_type
    target_replica_disk_type   = "Standard_LRS"
  }

  target_network_id = azurerm_virtual_network.dr.id

  network_interface {
    source_network_interface_id = data.terraform_remote_state.vm.outputs.windows_svr[count.index].virtual_machine_network_interface_id
    target_subnet_name          = azurerm_subnet.dr.name
  }

  depends_on = [
    azurerm_resource_group.linux,
    azurerm_site_recovery_protection_container_mapping.dr,
    azurerm_site_recovery_network_mapping.core
  ]
}


resource "azurerm_resource_group" "windows_wks" {
  provider = azurerm.sandbox
  count    = module.info.windows_wks_asr == true ? length(data.terraform_remote_state.vm.outputs.windows_wks) : 0

  name     = data.terraform_remote_state.vm.outputs.windows_wks[count.index].asr_resource_group_name
  location = module.info.secondary_region.name
}


resource "azurerm_site_recovery_replicated_vm" "windows_wks" {
  provider = azurerm.sandbox
  count    = module.info.windows_wks_asr == true ? length(data.terraform_remote_state.vm.outputs.windows_wks) : 0

  name                                      = "${data.terraform_remote_state.vm.outputs.windows_wks[count.index].virtual_machine_name}-asr"
  resource_group_name                       = azurerm_resource_group.dr.name
  recovery_vault_name                       = azurerm_recovery_services_vault.dr.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = data.terraform_remote_state.vm.outputs.windows_wks[count.index].virtual_machine_id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.dr.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = azurerm_resource_group.windows_wks[count.index].id #data.terraform_remote_state.vm.outputs.windows_wks_rg[count.index][data.terraform_remote_state.vm.outputs.windows_wks[count.index].resource_group_name]
  target_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = data.terraform_remote_state.vm.outputs.windows_wks_disk[count.index][data.terraform_remote_state.vm.outputs.windows_wks[count.index].virtual_machine_os_disk_name] #lower(data.azurerm_managed_disk.primary_vm_domain_controllers_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
    staging_storage_account_id = azurerm_storage_account.dr.id
    target_resource_group_id   = azurerm_resource_group.windows_wks[count.index].id #data.terraform_remote_state.vm.outputs.windows_wks_rg[count.index][data.terraform_remote_state.vm.outputs.windows_wks[count.index].resource_group_name]
    target_disk_type           = data.terraform_remote_state.vm.outputs.windows_wks[count.index].virtual_machine_os_storage_account_type
    target_replica_disk_type   = "Standard_LRS"
  }

  target_network_id = azurerm_virtual_network.dr.id

  network_interface {
    source_network_interface_id = data.terraform_remote_state.vm.outputs.windows_wks[count.index].virtual_machine_network_interface_id
    target_subnet_name          = azurerm_subnet.dr.name
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.dr,
    azurerm_site_recovery_network_mapping.core,
  ]
}