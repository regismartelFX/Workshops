#https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-with-powershell-desired-state-configuration?view=sql-server-ver16#get-the-sql-server-2017-installation-media
$ImagePath = 'C:\Sources\SW_DVD9_NTRL_SQL_Svr_Standard_Edtn_2019Dec2019_64Bit_English_OEM_VL_X22-22109.iso'
$Destination = 'C:\Sources\SQL2019\'

New-Item -Path $Destination -ItemType 'Directory' -ErrorAction 'SilentlyContinue'
$DiskImage = Mount-DiskImage -ImagePath $ImagePath -PassThru
$Volume = $DiskImage | Get-Volume
$PSDrive = Get-PSDrive -Name $Volume.DriveLetter
Copy-Item -Path (Join-Path -Path $PSDrive.Root -ChildPath '*') -Destination $Destination -Recurse
Dismount-DiskImage -ImagePath $ImagePath