resource "azurerm_subnet" "bastion" {
  provider = azurerm.sandbox

  name                 = "AzureBastionSubnet"
  resource_group_name  = data.terraform_remote_state.core.outputs.core_resource_group_name
  virtual_network_name = data.terraform_remote_state.core.outputs.core_virtual_network_name
  address_prefixes     = module.info.snet_core_sbx_azurebastionsubnet_address_prefixes_ip_range
}


#https://learn.microsoft.com/en-us/azure/bastion/configuration-settings#public-ip
resource "azurerm_public_ip" "bastion" {
  provider = azurerm.sandbox

  name                = "pip-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  location            = module.info.primary_region.name
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_bastion_host" "bastion" {
  provider = azurerm.sandbox

  name                = "bas-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  location            = module.info.primary_region.name
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}