variable "definition_references" {
  type        = set(string)
  description = "The IDs of the policy definitions or policy set definitions that will be included in this policy set definition."
}

variable "management_group_id" {
  type        = string
  default     = ""
  description = "The id of the Management Group where this policy should be defined, if it should be defined at the Management Group level."
}
