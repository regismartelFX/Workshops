data "azurerm_resource_group" "demo" {
  provider = azurerm.demo_1

  name = "rg-intactoperationalexcellence-p01"
}


resource "azurerm_automation_account" "demo" {
  provider = azurerm.demo_1

  name                = "aa-dsc-cc-p01"
  location            = module.info.primary_region.name
  resource_group_name = data.azurerm_resource_group.demo.name
  sku_name            = "Basic"
}