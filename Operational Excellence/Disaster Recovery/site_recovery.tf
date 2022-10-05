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
