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