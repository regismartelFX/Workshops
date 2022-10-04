output "vm" {
  value = [
    for vm in azurerm_linux_virtual_machine.vm : {
      "resource_group_name"                     = vm.resource_group_name,
      "asr_resource_group_name"                 = replace(vm.resource_group_name, "-vm${var.descriptive_context}-", "-vm${var.descriptive_context}asr-"),
      "virtual_machine_id"                      = vm.id
      "virtual_machine_name"                    = vm.name
      "virtual_machine_os_disk_name"            = vm.os_disk[0].name
      "virtual_machine_os_storage_account_type" = vm.os_disk[0].storage_account_type
      "virtual_machine_network_interface_id"    = vm.network_interface_ids[0]
    }
  ]
}


# output "rg" {
#   value = [
#     for rg in azurerm_resource_group.vm : {
#       "${rg.name}" = rg.id
#     }
#   ]
# }


output "disk" {
  value = [
    for disk in data.azurerm_managed_disk.vm : {
      "${disk.name}" = disk.id
    }
  ]
}
