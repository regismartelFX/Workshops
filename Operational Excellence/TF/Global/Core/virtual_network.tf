resource "azurerm_virtual_network" "core" {
  provider = azurerm.sandbox

  name                = "vnet-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  address_space       = module.info.vnet_core_sbx_address_space_ip_range
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
}


resource "azurerm_subnet" "core" {
  provider = azurerm.sandbox

  name                                      = "snet-${module.info.descriptive_context}"
  resource_group_name                       = azurerm_resource_group.core.name
  virtual_network_name                      = azurerm_virtual_network.core.name
  address_prefixes                          = module.info.snet_core_sbx_demo_address_prefixes_ip_range
  private_endpoint_network_policies_enabled = false
}