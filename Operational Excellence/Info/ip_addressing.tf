output "vnet_core_sbx_address_space_ip_range" {
  description = "The address space that is used for the core virtual network in the primary region for the sandbox subscription."
  value       = ["192.168.0.0/16"]
}


output "snet_core_sbx_demo_address_prefixes_ip_range" {
  description = "The address range of the demo subnet that is created in the core virtual network in the primary region for the sandbox subscription."
  value       = ["192.168.128.0/24"]
}


output "snet_core_sbx_azurebastionsubnet_address_prefixes_ip_range" {
  description = "The address range of the AzureBastionSubnet subnet that is created in the core virtual network in the primary region for the sandbox subscription."
  value       = ["192.168.0.192/26"]
}
