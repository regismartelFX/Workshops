################################################################################
### Policy assignment parameters
################################################################################

variable "subscription" {
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
    condition     = contains(["AuditIfNotExists", "DeployIfNotExists", "Disabled"], var.effect)
    error_message = "Allowed values: \"AuditIfNotExists\", \"DeployIfNotExists\" or \"Disabled\"."
  }
}

variable "vaultLocation" {
  type        = string
  description = "Policy parameter.  Specify the location of the VMs that you want to protect. VMs should be backed up to a vault in the same location. For example - CanadaCentral."
}

variable "inclusionTagName" {
  type        = string
  default     = "BackupPolicy"
  description = "Policy parameter.  Name of the tag to use for including VMs in the scope of this policy. This should be used along with the Inclusion Tag Value parameter. Learn more at https://aka.ms/AppCentricVMBackupPolicy."
}

variable "inclusionTagValue" {
  type        = list(string)
  description = "Policy parameter.  Value of the tag to use for including VMs in the scope of this policy, provided in the form of a list os strings. This should be used along with the Inclusion Tag Name parameter. Learn more at https://aka.ms/AppCentricVMBackupPolicy."
}

variable "backupPolicyId" {
  type        = string
  description = "Policy parameter.  Specify the ID of the Azure Backup policy to configure backup of the virtual machines. The selected Azure Backup policy should be of type Azure Virtual Machine. This policy needs to be in a vault that is present in the location chosen above. For example - /subscriptions/<SubscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.RecoveryServices/vaults/<VaultName>/backupPolicies/<BackupPolicyName>."
}
