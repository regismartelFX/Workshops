data "azurerm_resource_group" "demo" {
  provider = azurerm.demo_1

  name = "rg-intactoperationalexcellence-p01"
}


data "azurerm_virtual_network" "demo" {
  provider = azurerm.demo_1

  name                = "vnet-intactoperationalexcellence-p01"
  resource_group_name = data.azurerm_resource_group.demo.name
}