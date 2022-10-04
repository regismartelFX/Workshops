resource "azurerm_site_recovery_fabric" "primary" {
  provider = azurerm.sandbox

  name                = "${module.info.descriptive_context}-${module.info.primary_region.name}"
  resource_group_name = azurerm_resource_group.dr.name
  recovery_vault_name = azurerm_recovery_services_vault.dr.name
  location            = module.info.primary_region.name
}


resource "azurerm_site_recovery_fabric" "secondary" {
  provider = azurerm.sandbox

  name                = "${module.info.descriptive_context}-${module.info.secondary_region.name}"
  resource_group_name = azurerm_resource_group.dr.name
  recovery_vault_name = azurerm_recovery_services_vault.dr.name
  location            = module.info.secondary_region.name
}


resource "azurerm_site_recovery_protection_container" "primary" {
  provider = azurerm.sandbox

  name                 = "${module.info.descriptive_context}-${module.info.primary_region.name}"
  resource_group_name  = azurerm_resource_group.dr.name
  recovery_vault_name  = azurerm_recovery_services_vault.dr.name
  recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
}


resource "azurerm_site_recovery_protection_container" "secondary" {
  provider = azurerm.sandbox

  name                 = "${module.info.descriptive_context}-${module.info.secondary_region.name}"
  resource_group_name  = azurerm_resource_group.dr.name
  recovery_vault_name  = azurerm_recovery_services_vault.dr.name
  recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
}


resource "azurerm_site_recovery_replication_policy" "dr" {
  provider = azurerm.sandbox

  name                                                 = module.info.descriptive_context
  resource_group_name                                  = azurerm_resource_group.dr.name
  recovery_vault_name                                  = azurerm_recovery_services_vault.dr.name
  recovery_point_retention_in_minutes                  = 24 * 60
  application_consistent_snapshot_frequency_in_minutes = 3 * 60
}

resource "azurerm_site_recovery_protection_container_mapping" "dr" {
  provider = azurerm.sandbox

  name                                      = module.info.descriptive_context
  resource_group_name                       = azurerm_resource_group.dr.name
  recovery_vault_name                       = azurerm_recovery_services_vault.dr.name
  recovery_fabric_name                      = azurerm_site_recovery_fabric.primary.name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.primary.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.secondary.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.dr.id
}


resource "azurerm_site_recovery_network_mapping" "core" {
  provider = azurerm.sandbox

  name                        = "${module.info.descriptive_context}-core"
  resource_group_name         = azurerm_resource_group.dr.name
  recovery_vault_name         = azurerm_recovery_services_vault.dr.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.primary.name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.secondary.name
  source_network_id           = data.terraform_remote_state.core.outputs.core_virtual_network_id
  target_network_id           = azurerm_virtual_network.dr.id
}





# #####
# # Azure Site Recovery Replicated VM
# #####
# resource "azurerm_site_recovery_replicated_vm" "vm_domain_controllers_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_domain_controllers_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_domain_controllers_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_domain_controllers_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_domain_controllers_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_domain_controllers_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_domain_controllers_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_domain_controllers_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_domain_controllers_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_domain_controllers_2_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_domain_controllers_2.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_domain_controllers_2.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_domain_controllers_2_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_domain_controllers_2_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_domain_controllers_2_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_domain_controllers_2_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_domain_controllers_2_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_domain_controllers_2_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_file_servers_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_file_servers_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_file_servers_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_file_servers_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_file_servers_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_file_servers_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_file_servers_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_file_servers_1_data_1_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_file_servers_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_file_servers_1_data_1_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_file_servers_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_file_servers_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "960m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_centaur_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_centaur_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_centaur_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_centaur_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_centaur_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_centaur_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_centaur_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_centaur_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_centaur_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_proxy_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_proxy_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_proxy_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_proxy_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_proxy_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_proxy_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_proxy_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_proxy_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_proxy_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_ad_connect_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_ad_connect_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_ad_connect_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_ad_connect_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_ad_connect_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_ad_connect_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_ad_connect_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_ad_connect_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_ad_connect_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_exchange_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_exchange_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_exchange_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_exchange_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_exchange_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_exchange_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_exchange_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_exchange_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_exchange_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_pasm_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_pasm_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_pasm_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_pasm_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_pasm_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_pasm_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_pasm_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_pasm_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_pasm_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_pasm_2_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_pasm_2.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_pasm_2.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_pasm_2_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_pasm_2_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_pasm_2_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_pasm_2_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_pasm_2_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_pasm_2_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_rds_sage_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_rds_sage_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_rds_sage_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_rds_sage_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_rds_sage_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_rds_sage_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_rds_sage_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_rds_sage_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_rds_sage_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_sql_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_sql_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_sql_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_data_1_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_data_1_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_data_2_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_data_2_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_data_3_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_data_3_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_data_4_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_data_4_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_sql_1_data_5_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_sql_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_sql_1_data_5_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_sharedservices.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_sql_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_sql_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_sharedservices_subnet.name
#   }

#   timeouts {
#     create = "480m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_ras_gateway_1_replicated_vm" {
#   provider = azurerm.sandbox

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_ras_gateway_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_ops_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_ras_gateway_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_ras_gateway_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_ras_gateway_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_ras_gateway_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_ras_gateway_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_dmz.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_ras_gateway_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_ras_gateway_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_dmz_subnet.name
#   }

#   timeouts {
#     create = "240m"
#     delete = "30m"
#   }
# }

# resource "azurerm_site_recovery_replicated_vm" "vm_alienvaultusm_1_replicated_vm" {
#   provider = azurerm.SBSEC

#   name                                       = "${data.azurerm_virtual_machine.primary_vm_alienvaultusm_1.name}-asr"
#   resource_group_name                        = data.azurerm_recovery_services_vault.secondary_sec_recovery_services_vault.resource_group_name
#   recovery_vault_name                        = data.azurerm_recovery_services_vault.secondary_sec_recovery_services_vault.name
#   primary_recovery_fabric_name               = azurerm_site_recovery_fabric.primary_site_recovery_fabric_sec.name
#   primary_vm_id                              = data.azurerm_virtual_machine.primary_vm_alienvaultusm_1.id
#   recovery_replication_policy_id             = azurerm_site_recovery_replication_policy.site_recovery_replication_policy_sec.id
#   primary_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary_site_recovery_protection_container_sec.name

#   secondary_resource_group_id                = data.azurerm_resource_group.secondary_vm_alienvaultusm_1_resource_group.id
#   secondary_recovery_fabric_id               = azurerm_site_recovery_fabric.secondary_site_recovery_fabric_sec.id
#   secondary_recovery_protection_container_id = azurerm_site_recovery_protection_container.secondary_site_recovery_protection_container_sec.id

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_alienvaultusm_1_os_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache_sec.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_alienvaultusm_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_alienvaultusm_1_os_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   managed_disk {
#     disk_id                     = lower(data.azurerm_managed_disk.primary_vm_alienvaultusm_1_data_1_disk.id) #https://github.com/terraform-providers/terraform-provider-azurerm/issues/8416 - azurerm_site_recovery_replicated_vm tries to recreate every time due to inconsistent text upper/lowercase
#     staging_storage_account_id  = data.azurerm_storage_account.primary_sa_azure_site_recovery_cache_sec.id
#     secondary_resource_group_id = data.azurerm_resource_group.secondary_vm_alienvaultusm_1_resource_group.id
#     secondary_disk_type         = data.azurerm_managed_disk.primary_vm_alienvaultusm_1_data_1_disk.storage_account_type
#     secondary_replica_disk_type = "Standard_LRS"
#   }

#   secondary_network_id = data.azurerm_virtual_network.secondary_vnet_prod_security.id

#   network_interface {
#     primary_network_interface_id = data.azurerm_network_interface.primary_vm_alienvaultusm_1_network_interface.id
#     secondary_static_ip          = data.azurerm_network_interface.primary_vm_alienvaultusm_1_network_interface.private_ip_address
#     secondary_subnet_name        = data.azurerm_subnet.secondary_vnet_prod_security_subnet.name
#   }

#   timeouts {
#     create = "480m"
#     delete = "30m"
#   }
# }