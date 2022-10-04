resource "azurerm_virtual_network" "dr" {
  provider = azurerm.sandbox

  name                = "vnet-${module.info.descriptive_context}-${module.info.secondary_region.code}-${module.info.sandbox.short_name}01"
  address_space       = module.info.vnet_asr_sbx_address_space_ip_range
  location            = module.info.secondary_region.name
  resource_group_name = azurerm_resource_group.dr.name
}


resource "azurerm_subnet" "dr" {
  provider = azurerm.sandbox

  name                                      = "snet-${module.info.descriptive_context}"
  resource_group_name                       = azurerm_resource_group.dr.name
  virtual_network_name                      = azurerm_virtual_network.dr.name
  address_prefixes                          = module.info.snet_asr_sbx_demo_address_prefixes_ip_range
  private_endpoint_network_policies_enabled = false
}