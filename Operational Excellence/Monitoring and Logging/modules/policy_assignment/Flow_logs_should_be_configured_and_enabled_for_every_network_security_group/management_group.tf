terraform {
  required_version = ">= 1.0.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.92.0"
    }
  }
}


locals {
  policy_definition = {
    name = "Flow logs should be configured and enabled for every network security group"
    id   = "/providers/Microsoft.Authorization/policySetDefinitions/62329546-775b-4a3d-a4cb-eb4bb990d2c0"
  }
  management_group_policy_assignment = var.management_group.id != null
  effect                             = "\"${var.effect}\""
  display_name                       = local.management_group_policy_assignment ? "Initiative \"${local.policy_definition.name}\" on ${var.management_group.name}" : ""
}


resource "azurerm_management_group_policy_assignment" "this" {

  count                = local.management_group_policy_assignment ? 1 : 0
  policy_definition_id = local.policy_definition.id
  name                 = substr("policy-${replace(uuidv5("oid", local.display_name), "-", "")}", 0, 24)
  management_group_id  = var.management_group.id
  not_scopes           = var.not_scopes
  description          = var.description
  display_name         = local.display_name
  enforce              = var.enforce
  parameters           = <<PARAMETERS
    {
      "effect":
      {
        "value": ${local.effect}
      }
    }
    PARAMETERS
}
