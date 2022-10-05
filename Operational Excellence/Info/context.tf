output "descriptive_context" {
  description = "Will be used to infer resources name."
  value       = "demo" #Keep under 4 caracters to avoid having to rename resources, especially azurerm_storage_account.dr
}


output "email_receiver_name" {
  description = "The name of the email receiver for Azure Monitor Action Group."
  value       = "Régis Martel"
}


output "email_receiver_email_address" {
  description = "The email address of the receiver for Azure Monitor Action Group."
  value       = "regis.martel@fxinnovation.com"
}


output "core_key_vault_random" {
  description = "5 characters [a-z0-9] that will be used to make the core key vault resource name unique."
  value       = "x4jn3"
}


output "core_storage_account_random" {
  description = "5 characters [a-z0-9] that will be used to make the core storage account resource name unique."
  value       = "77d7h"
}


output "vm_storage_account_random" {
  description = "5 characters [a-z0-9] that will be used to make the vm storage account resource name unique."
  value       = "90qzo"
}


output "dr_storage_account_random" {
  description = "5 characters [a-z0-9] that will be used to make the dr storage account resource name unique."
  value       = "g6gcv"
}