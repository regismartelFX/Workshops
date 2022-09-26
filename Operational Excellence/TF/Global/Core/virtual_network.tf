resource "azurerm_virtual_network" "core" {
  provider = azurerm.sandbox

  name                = "vnet-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  address_space       = ["192.168.0.0/16"]
  location            = module.info.primary_region.name
  resource_group_name = azurerm_resource_group.core.name
}


resource "azurerm_subnet" "core" {
  provider = azurerm.sandbox

  name                                      = "snet-${module.info.descriptive_context}"
  resource_group_name                       = azurerm_resource_group.core.name
  virtual_network_name                      = azurerm_virtual_network.core.name
  address_prefixes                          = ["192.168.128.0/24"]
  private_endpoint_network_policies_enabled = false
}