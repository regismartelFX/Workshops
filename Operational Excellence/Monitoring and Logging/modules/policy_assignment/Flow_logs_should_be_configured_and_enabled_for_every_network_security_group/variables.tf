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


################################################################################
### Policy parameters
################################################################################

variable "effect" {
  type        = string
  default     = "Audit"
  description = "Policy parameter.  Enable or disable the execution of the policy."

  validation {
    condition     = contains(["Audit", "Disabled"], var.effect)
    error_message = "Allowed values: \"Audit\" or \"Disabled\"."
  }
}
