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