resource "azurerm_automation_dsc_configuration" "sql" {
  name                    = "test"
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  location                = azurerm_resource_group.example.location
  content_embedded        = <<CONTENT_EMBEDDED
Configuration SQLInstall
{
     Import-DscResource -ModuleName 'SqlServerDsc'
     Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

     node localhost
     {
          WindowsFeature 'NetFramework45'
          {
               Name   = 'NET-Framework-45-Core'
               Ensure = 'Present'
          }

          SqlSetup 'InstallDefaultInstance'
          {
               InstanceName        = 'MSSQLSERVER'
               Features            = 'SQLENGINE'
               SourcePath          = 'C:\Sources\SQL2019\'
               SQLSysAdminAccounts = @('Administrators')
               DependsOn           = '[WindowsFeature]NetFramework45'
          }

          Package 'SSMS' {
               Ensure = 'Present'
               Name = "SSMS-Setup-ENU"
               Path = 'C:\Sources\SSMS\SSMS-Setup-ENU.exe'
               Arguments = '/install /passive /norestart'
               ProductId ='ECC23FD6-535B-43CB-894B-F47FA605EBB3' # SQL Server Management Studio 15.0.18424.0
          }
     }
}
  CONTENT_EMBEDDED
}







