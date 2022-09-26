variable "quantity" {
  type        = number
  default     = 1
  description = "Number of VMs to deploy.  Will be used to infer resources name."

  validation {
    condition     = var.quantity >= 1 && var.quantity <= 99
    error_message = "quantity must be between 1 and 99."
  }
}


variable "seed" {
  type        = number
  default     = 1
  description = "First sequential number.  Will be used to infer resources name."

  validation {
    condition     = var.seed >= 1 && var.seed <= 98
    error_message = "quantity must be between 1 and 98."
  }
}


variable "descriptive_context" {
  type        = string
  description = "Will be used to infer resources name."

  validation {
    condition     = length(var.descriptive_context) <= 24
    error_message = "descriptive_context length must be inferior or equal to 24."
  }
}


variable "environment" {
  type        = string
  description = "Will be used to infer resources name."

  validation {
    condition     = length(var.environment) == 1
    error_message = "environment length must be exactly 1."
  }
}


variable "location" {
  type = string
}


variable "stdiag_resource_group_name" {
  type = string
}


variable "stdiag_name" {
  type = string
}


variable "core_resource_group_name" {
  type = string
}


variable "core_key_vault_name" {
  type = string
}


variable "core_key_vault_admin_secret_name" {
  type = string
}


variable "core_key_vault_adminpwd_secret_name" {
  type = string
}


variable "core_virtual_network_name" {
  type = string
}


variable "core_subnet_name" {
  type = string
}


variable "core_log_analytics_workspace_name" {
  type = string
}


variable "size" {
  type = string
}


variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}


variable "tags" {
  type    = map(string)
  default = {}
}