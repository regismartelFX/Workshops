data "azurerm_resource_group" "demo" {
  provider = azurerm.sandbox

  name = "rg-intactoperationalexcellence-p01"
}


data "azurerm_storage_account" "sadiag" {
  name                = "sadiagintactdemodr54da"
  resource_group_name = data.azurerm_resource_group.demo.name
}