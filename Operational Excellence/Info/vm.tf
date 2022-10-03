output "dsc_sqlinstall" {
  description = "true to install SQLServer using DSC, false to skip."
  value       = false
}


output "default_vm_admin_account_name" {
  description = "Name of the default admin account created with the VMs."
  value       = "Demo"
}


output "linux_source_image_reference" {
  description = "Preferred publisher, offer, SKU and version for the Linux VMs."
  value = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}


output "linux_size" {
  description = "Preferred size for the Linux VMs."
  value       = "Standard_B2ms"
}


output "windows_svr_source_image_reference" {
  description = "Preferred publisher, offer, SKU and version for the Linux VMs."
  value = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}


output "windows_svr_size" {
  description = "Preferred size for the Linux VMs."
  value       = "Standard_B4ms"
}


output "windows_wks_source_image_reference" {
  description = "Preferred publisher, offer, SKU and version for the Linux VMs."
  value = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }
}


output "windows_wks_size" {
  description = "Preferred size for the Linux VMs."
  value       = "Standard_D2s_v3"
}