#Requires -Modules @{ ModuleName = 'Az'; ModuleVersion = '8.3.0' }

[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$ContextTenant,
    [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$ContextSubscription,
    [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$NamingConventionDescriptiveContext = 'test',
    [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$NamingConventionEnvironmentCode = 't',
    [Parameter(Mandatory = $False)][ValidateRange(1, 99)][Int]$NamingConventionSequentialNumber = 1
)
$ErrorActionPreference = 'Stop'
Set-Item -Path 'Env:SuppressAzurePowerShellBreakingChangeWarnings' -Value 'true'
Update-AzConfig -DisplayBreakingChangeWarning:$False | Out-Null

#region Variables
$NamingConvention = @{
    DescriptiveContext = $NamingConventionDescriptiveContext
    EnvironmentCode    = $NamingConventionEnvironmentCode
    SequentialNumber   = ([String]$NamingConventionSequentialNumber).PadLeft(2, '0')
}

$Context = @{
    Tenant       = $ContextTenant
    Subscription = $ContextSubscription
    Location     = 'canadacentral'
}

$VM = @{
    ResourceGroupName = "rg-$($NamingConvention.DescriptiveContext)-$($NamingConvention.EnvironmentCode)$($NamingConvention.SequentialNumber)" #Infer name of RG from naming convention
    #ResourceGroupName = 'rg-gs1testvm-t01' #Hard-code name of RG
}

$VirtualNetwork = @{
    #ResourceGroupName = $VM.ResourceGroupName #Use the same RG as the VM
    ResourceGroupName   = 'rg-intactoperationalexcellence-p01' #Hard-code name of RG but use a different RG than the VM
    #ResourceGroupName = "rg-$($NamingConvention.DescriptiveContext)network-$($NamingConvention.EnvironmentCode)$($NamingConvention.SequentialNumber)" #Infer name of RG from naming convention but use a different RG than the VM
    #Name = "vnet-$($NamingConvention.DescriptiveContext)-$($NamingConvention.EnvironmentCode)$($NamingConvention.SequentialNumber)" #Infer name of VNet from naming convention
    Name                = 'vnet-intactoperationalexcellence-p01' #Hard-code name of VNet
    AddressPrefix       = '192.168.0.0/16'
    SubnetConfigName    = "snet-$($NamingConvention.DescriptiveContext)" #Infer name of subnet from naming convention
    #SubnetConfigName = 'snet-test' #Hard-code name of subnet
    SubnetAddressPrefix = '192.168.128.0/24'
}

$StorageAccount = @{
    #ResourceGroupName = $VM.ResourceGroupName #Use the same RG as the VM
    ResourceGroupName = 'rg-intactoperationalexcellence-p01' #Hard-code name of RG but use a different RG than the VM
    #ResourceGroupName = "rg-$($NamingConvention.DescriptiveContext)sadiag-$($NamingConvention.EnvironmentCode)$($NamingConvention.SequentialNumber)" #Infer name of RG from naming convention but use a different RG than the VM
    #Name = -join ('sadiag', $( -join ((0x30..0x39) + ( 0x61..0x7A) | Get-Random -Count 8 | ForEach-Object { [char]$_ }))) #Use a random name for the storage account
    Name              = 'sadiagintactdemodr54da' #Hard-code name of storage account
    SkuName           = 'Standard_LRS'
}

$VMConfig = @{
    VMName = "vm-$($NamingConvention.DescriptiveContext)-$($NamingConvention.EnvironmentCode)$($NamingConvention.SequentialNumber)" #Infer name of VM from naming convention
    #VMName = 'vm-test-t01' #Hard-code name of VM
    VMSize = 'Standard_B4ms'
}

#If $VMConfig.VMName is not a valid hostname, try to generate a valid hostname until successful.
#^(?![0-9]{1,15}$)[a-zA-Z0-9-]{1,15}$ matches valid Windows computer name (not more than 15 characters long, entirely numeric, and does not contain any of the following characters: ` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \ | ; : . ' " , < > / ?.
$ComputerName = $VMConfig.VMName
While ($ComputerName -notmatch '^(?![0-9]{1,15}$)[a-zA-Z0-9-]{1,15}$') {
    $ComputerName = $( -join ((0x30..0x39) + ( 0x61..0x7A) | Get-Random -Count 15 | ForEach-Object { [char]$_ })).ToUpper()
}

$Credential = @{
    Username = 'regis'
    Password = '!QWertyuiOP90'
}

$VMOperatingSystem = @{
    Windows          = $True
    ComputerName     = $ComputerName
    Credential       = New-Object -TypeName 'System.Management.Automation.PSCredential' -Args @($Credential.Username, $(ConvertTo-SecureString -String $Credential.Password -AsPlainText -Force))
    PatchMode        = 'AutomaticByOS'
    ProvisionVMAgent = $True
    EnableAutoUpdate = $True
}

$VMSourceImage = @{
    PublisherName = 'MicrosoftWindowsServer' #'MicrosoftWindowsDesktop'
    Offer         = 'WindowsServer' #'windows-11'
    Skus          = '2022-datacenter' #'win11-21h2-pro'
    Version       = 'latest'
}

$VMNetworkInterface = @{
    AzNetworkInterfaceName = "$($VMConfig.VMName)-nic01"
}

$VMBootDiagnostic = @{
    Enable             = $True
    ResourceGroupName  = $StorageAccount.ResourceGroupName
    StorageAccountName = $StorageAccount.Name
}
#endregion Variables


#region ConnectToAzure
If (-not ($env:AZUREPS_HOST_ENVIRONMENT)) {
    #Not required when script is executed in CloudShell
    If (-not(Get-AzAccessToken -TenantId $Context.Tenant -ErrorAction 'SilentlyContinue')) {
        Connect-AzAccount -Tenant $Context.Tenant -Subscription $Context.Subscription
    }
}
Set-AzContext -Tenant $Context.Tenant -Subscription $Context.Subscription
#endregion ConnectToAzure


#region New-AzVM #You should have to modify anything in that region
$AzResourceGroup = Get-AzResourceGroup -Name $VM.ResourceGroupName -Location $Context.Location -ErrorAction 'SilentlyContinue'
If (!$AzResourceGroup) {
    $AzResourceGroup = New-AzResourceGroup -Name $VM.ResourceGroupName -Location $Context.Location
}

$AzVirtualNetworkResourceGroup = Get-AzResourceGroup -Name $VirtualNetwork.ResourceGroupName -Location $Context.Location -ErrorAction 'SilentlyContinue'
If (!$AzVirtualNetworkResourceGroup) {
    $AzVirtualNetworkResourceGroup = New-AzResourceGroup -Name $VirtualNetwork.ResourceGroupName -Location $Context.Location
}

$AzVirtualNetwork = Get-AzVirtualNetwork -Name $VirtualNetwork.Name -ResourceGroupName $VirtualNetwork.ResourceGroupName -ErrorAction 'SilentlyContinue'
If (!$AzVirtualNetwork) {
    $SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $VirtualNetwork.SubnetConfigName -AddressPrefix $VirtualNetwork.SubnetAddressPrefix
    $AzVirtualNetwork = New-AzVirtualNetwork -Name $VirtualNetwork.Name -ResourceGroupName $VirtualNetwork.ResourceGroupName -Location $Context.Location -AddressPrefix $VirtualNetwork.AddressPrefix -Subnet $SubnetConfig
}

$SubnetConfig = $AzVirtualNetwork | Get-AzVirtualNetworkSubnetConfig -Name $VirtualNetwork.SubnetConfigName
$AzNetworkInterface = New-AzNetworkInterface -Name $VMNetworkInterface.AzNetworkInterfaceName -ResourceGroupName $VM.ResourceGroupName -Location $Context.Location -Subnet $SubnetConfig -Force


$AzStorageAccountResourceGroup = Get-AzResourceGroup -Name $StorageAccount.ResourceGroupName -Location $Context.Location -ErrorAction 'SilentlyContinue'
If (!$AzStorageAccountResourceGroup) {
    $AzStorageAccountResourceGroup = New-AzResourceGroup -Name $StorageAccount.ResourceGroupName -Location $Context.Location
}
$AzStorageAccount = Get-AzStorageAccount -Name $StorageAccount.Name -ResourceGroupName $StorageAccount.ResourceGroupName -ErrorAction 'SilentlyContinue'
If (!$AzStorageAccount) {
    $AzStorageAccount = New-AzStorageAccount -ResourceGroupName $StorageAccount.ResourceGroupName -Location $Context.Location -Name $StorageAccount.Name -SkuName $StorageAccount.SkuName
}

$AzVMConfig = New-AzVMConfig @VMConfig
$AzVMConfig | Set-AzVMOperatingSystem @VMOperatingSystem | Out-Null
$AzVMConfig | Set-AzVMSourceImage @VMSourceImage | Out-Null
$AzVMConfig | Add-AzVMNetworkInterface -NetworkInterface $AzNetworkInterface | Out-Null
$AzVMConfig | Set-AzVMBootDiagnostic @VMBootDiagnostic | Out-Null

New-AzVM -ResourceGroupName $VM.ResourceGroupName -Location $Context.Location -VM $AzVMConfig -AsJob
Remove-Item -Path 'Env:SuppressAzurePowerShellBreakingChangeWarnings' -Confirm:$False -Force
#endregion New-AzVM
