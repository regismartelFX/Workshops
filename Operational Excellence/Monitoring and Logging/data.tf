data "azurerm_management_group" "root" {
  name = "mg-root"
}


data "azurerm_subscription" "sandbox" {
  provider = azurerm.sandbox
}


data "azurerm_resource_group" "networkwatcher" {
  provider = azurerm.sandbox

  name = "NetworkWatcherRG"
}


data "azurerm_network_watcher" "networkwatcher_canadacentral" {
  provider = azurerm.sandbox

  name                = "NetworkWatcher_canadacentral"
  resource_group_name = data.azurerm_resource_group.networkwatcher.name
}