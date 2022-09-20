data "azurerm_resource_group" "demo" {
  provider = azurerm.demo_1

  name = "rg-intactoperationalexcellence-p01"
}


data "azurerm_storage_account" "sadiag" {
  name                = "sadiagintactdemodr54da"
  resource_group_name = data.azurerm_resource_group.demo.name
}