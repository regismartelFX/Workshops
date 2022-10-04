output "stdiag_storage_account_id" {

  value = azurerm_storage_account.stdiag.id
}


output "linux" {

  value = module.linux.vm
}


# output "linux_rg" {

#   value = module.linux.rg
# }


output "linux_disk" {

  value = module.linux.disk
}


output "windows_svr" {

  value = module.windows_svr.vm
}


# output "windows_svr_rg" {

#   value = module.windows_svr.rg
# }


output "windows_svr_disk" {

  value = module.windows_svr.disk
}


output "windows_wks" {

  value = module.windows_wks.vm
}


# output "windows_wks_rg" {

#   value = module.windows_wks.rg
# }


output "windows_wks_disk" {

  value = module.windows_wks.disk
}
