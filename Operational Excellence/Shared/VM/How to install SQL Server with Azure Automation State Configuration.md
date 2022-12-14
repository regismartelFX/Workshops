# How to install SQL Server with Azure Automation State Configuration

Refer to [Install SQL Server with PowerShell Desired State Configuration](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16).

To leverage Azure Automation State Configuration, follow the steps in the article with the following modifications:
1. [Install the SqlServerDsc DSC resource](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#install-the-sqlserverdsc-dsc-resource)
    - Import the module SqlServerDsc in the Automation account modules
2. [Get the SQL Server 2017 installation media](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#get-the-sql-server-2017-installation-media)
    - Ask someone who has access to the benefits in the Microsoft Partner Center to download the iso for you if you don't have access
    - Copy the .iso on the target computer and use the following script to create the installation media folder.
        ```powershell
        #https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#get-the-sql-server-2017-installation-media
        $ImagePath = 'C:\Sources\SW_DVD9_NTRL_SQL_Svr_Standard_Edtn_2019Dec2019_64Bit_English_OEM_VL_X22-22109.iso'
        $Destination = 'C:\Sources\SQL2019\'

        New-Item -Path $Destination -ItemType 'Directory' -ErrorAction 'SilentlyContinue'
        $DiskImage = Mount-DiskImage -ImagePath $ImagePath -PassThru
        $Volume = $DiskImage | Get-Volume
        $PSDrive = Get-PSDrive -Name $Volume.DriveLetter
        Copy-Item -Path (Join-Path -Path $PSDrive.Root -ChildPath '*') -Destination $Destination -Recurse
        Dismount-DiskImage -ImagePath $ImagePath
        ```
    - On the target computer, [download SSMS installation](https://aka.ms/ssmsfullsetup) file to a local disk.
3. [Create the configuration](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#create-the-configuration)
    - Use ./SQLInstallConfiguration.ps1 from this folder.  Update the SqlSetup(InstallDefaultInstance).SourcePath and Package(SSMS).Path and  if you changed the variable $Destination in the previous step.
    - Install SSMS on a different computer a run `Get-WmiObject Win32_Product | Format-Table IdentifyingNumber, Name, Version` to get the product ID and update Package(SSMS).ProductId.    
    - Upload the configuration in the Automation account > State configuration (DSC) > Configurations
4. [Build and deploy](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#build-and-deploy)
    - Compile the configuration you have created at the previous step to created the "Compiled configuration" (mof)
5. [Deploy the configuration](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#deploy-the-configuration)
    - Add the computers to Automation account > State configuration (DSC) > Nodes to deploy the configuration
6. [Validate installation](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#validate-installation)
    - As is
7. If required, create test databases using the [Northwind and Pubs samples](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs) from Microsoft.
