resource "azurerm_subnet" "bastionsubnet" {
  provider = azurerm.demo_1

  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.demo.name
  virtual_network_name = data.azurerm_virtual_network.demo.name
  address_prefixes     = ["192.168.0.192/26"]
}


#https://learn.microsoft.com/en-us/azure/bastion/configuration-settings#public-ip
resource "azurerm_public_ip" "demo" {
  provider = azurerm.demo_1

  name                = "pip-demobastion-cc-p01"
  location            = module.info.primary_region.name
  resource_group_name = data.azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_bastion_host" "demo" {
  name                = "demobastion"
  location            = module.info.primary_region.name
  resource_group_name = data.azurerm_resource_group.demo.name

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.demo.id
  }
}