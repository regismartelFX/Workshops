output "vhub_networking_prod_address_prefix_ip_range" {
  description = "The Address Prefix which should be used for the prodution Virtual Hub in the primary region."
  value       = "10.193.16.0/24"
}

output "vnet_shared_services_prod_address_space_ip_range" {
  description = "The address space that is used the prodution virtual network in the primary region for the shared services subscription."
  value       = ["10.74.19.0/24"]
}

output "snet_shared_services_prod_adds_address_prefixes_ip_range" {
  description = "The address space that is used the prodution virtual network in the primary region for the shared services subscription."
  value       = ["10.74.19.0/28"]
}

output "vnet_shared_services_dev_address_space_ip_range" {
  description = "The address space that is used the development virtual network in the primary region for the shared services subscription."
  value       = ["10.74.119.0/24"]
}

output "vnet_security_prod_address_space_ip_range" {
  description = "The address space that is used the prodution virtual network in the primary region for the shared services subscription."
  value       = ["10.74.18.0/24"]
}

output "snet_security_prod_zscaler_address_prefixes_ip_range" {
  description = "The address range of the zscaler subnet that is used the prodution virtual network in the primary region for the security subscription."
  value       = ["10.74.18.0/28"]
}

output "snet_security_prod_alienvault_address_prefixes_ip_range" {
  description = "The address range of the alienvault subnet that is used the prodution virtual network in the primary region for the security subscription."
  value       = ["10.74.18.16/28"]
}

output "snet_security_prod_generic_address_prefixes_ip_range" {
  description = "The address range of the generic subnet that is used the prodution virtual network in the primary region for the security subscription."
  value       = ["10.74.18.64/26"]
}

output "vnet_security_dev_address_space_ip_range" {
  description = "The address space that is used the development virtual network in the primary region for the shared services subscription."
  value       = ["10.74.118.0/24"]
}

output "vnet_tools_prod_address_space_ip_range" {
  description = "The address space that is used the prodution virtual network in the primary region for the tools subscription."
  value       = ["10.74.20.0/24"]
}

output "snet_tools_prod_fxcozca2ptolsn004_address_prefixes_ip_range" {
  description = "The address space that is used the prodution virtual network in the primary region for the tools subscription."
  value       = ["10.74.20.192/26"]
}

output "vnet_tools_dev_address_space_ip_range" {
  description = "The address space that is used the development virtual network in the primary region for the tools subscription."
  value       = ["10.74.120.0/24"]
}
