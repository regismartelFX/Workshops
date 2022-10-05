#Does not work very well.  Use the manual method in Operational Excellence/Global/VM/How to install SQL Server with Azure Automation State Configuration.md
#For this configuration to work (theorically), you need to compile SQLInstall.ps1 locally to create the .mof file.

resource "azurerm_automation_module" "sqlserverdsc" {
  provider = azurerm.sandbox
  count    = module.info.dsc_sqlinstall == true ? 1 : 0

  name                    = "SqlServerDsc"
  resource_group_name     = data.terraform_remote_state.core.outputs.core_resource_group_name
  automation_account_name = data.terraform_remote_state.core.outputs.core_automation_account_name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/SqlServerDsc/16.0.0"
  }
}

resource "azurerm_automation_dsc_configuration" "sqlinstall" {
  provider = azurerm.sandbox
  count    = module.info.dsc_sqlinstall == true ? 1 : 0

  name                    = "SQLInstall"
  resource_group_name     = data.terraform_remote_state.core.outputs.core_resource_group_name
  automation_account_name = data.terraform_remote_state.core.outputs.core_automation_account_name
  location                = module.info.primary_region.name
  content_embedded        = "Configuration SQLInstall {}"
}

resource "azurerm_automation_dsc_nodeconfiguration" "sqlinstall" {
  provider = azurerm.sandbox
  count    = module.info.dsc_sqlinstall == true ? 1 : 0

  name                    = "SQLInstall.localhost"
  resource_group_name     = data.terraform_remote_state.core.outputs.core_resource_group_name
  automation_account_name = data.terraform_remote_state.core.outputs.core_automation_account_name
  content_embedded        = file("${path.cwd}/sqlinstall/localhost.mof")

  depends_on = [azurerm_automation_dsc_configuration.sqlinstall]
}