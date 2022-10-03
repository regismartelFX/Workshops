################################################################################
### Policy assignment parameters
################################################################################

variable "management_group" {
  type = object({
    id   = string
    name = string
  })
  description = "An object that represents the scope on which the policy will be applied."
}

variable "not_scopes" {
  type        = list(string)
  default     = []
  description = "A list of ids of scopes on which the policy will not be applied.  Id to be provided in the form \"/providers/Microsoft.Management/managementGroups/FXINNOVATION\", which doesn't equate the ID displayed in the portal.  Use Get-AzManagementGroup to fetch the Id."
}

variable "description" {
  type        = string
  default     = ""
  description = "A description which should be used for this Policy Assignment."
}

variable "enforce" {
  type        = bool
  default     = true
  description = "Specifies if this Policy should be enforced or not."
}

variable "location" {
  type        = string
  description = "The Azure Region where the Policy Assignment should exist."
}


################################################################################
### Policy parameters
################################################################################

variable "effect" {
  type        = string
  default     = "DeployIfNotExists"
  description = "Policy parameter.  Enable or disable the execution of the policy."

  validation {
    condition     = contains(["DeployIfNotExists", "Disabled"], var.effect)
    error_message = "Allowed values: \"DeployIfNotExists\" or \"Disabled\"."
  }
}

variable "nsgRegion" {
  type        = string
  description = "Policy parameter.  Configures for network security groups in the selected region only."
}

variable "storageId" {
  type        = string
  description = "Policy parameter.  Resource ID of the storage account where the flow logs are written. Make sure this storage account is located in the selected network security group Region. The format must be: '/subscriptions/{subscription id}/resourceGroups/{resourceGroup name}/providers/Microsoft.Storage/storageAccounts/{storage account name}."
}

variable "timeInterval" {
  type        = string
  default     = "60"
  description = "Policy parameter.  Traffic analytics processes blobs at the selected frequency."

  validation {
    condition     = contains(["10", "60"], var.timeInterval)
    error_message = "Allowed values: \"60\" or \"10\"."
  }
}

variable "workspaceResourceId" {
  type        = string
  description = "Policy parameter.  Log Analytics workspace resource id."
}

variable "workspaceRegion" {
  type        = string
  description = "Policy parameter.  Log Analytics workspace region."
}

variable "workspaceId" {
  type        = string
  description = "Policy parameter.  Log Analytics workspace GUID."
}

variable "networkWatcherRG" {
  type        = string
  description = "Policy parameter.  The Network Watcher regional instance is present in this resource group. The network security group flow logs resources are also created. This will be used only if a deployment is required. By default, it is named 'NetworkWatcherRG'."
}

variable "networkWatcherName" {
  type        = string
  description = "Policy parameter.  The name of the network watcher under which the flow log resources are created. Make sure it belongs to the same region as the network security group."
}
