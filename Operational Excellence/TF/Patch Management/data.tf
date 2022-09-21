data "azurerm_subscription" "demo_1" {
  subscription_id = "bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
}


data "azurerm_resource_group" "demo" {
  provider = azurerm.demo_1

  name = "rg-intactoperationalexcellence-p01"
}


data "azurerm_log_analytics_workspace" "demo" {
  provider = azurerm.demo_1

  name                = "log-demo-p01"
  resource_group_name = data.azurerm_resource_group.demo.name
}


data "azurerm_automation_account" "demo" {
  provider = azurerm.demo_1

  name                = "aa-dsc-cc-p01"
  resource_group_name = data.azurerm_resource_group.demo.name
}