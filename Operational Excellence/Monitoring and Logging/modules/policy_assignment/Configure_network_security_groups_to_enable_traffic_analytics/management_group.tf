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
    name = "Configure network security groups to enable traffic analytics"
    id   = "/providers/Microsoft.Authorization/policyDefinitions/e920df7f-9a64-4066-9b58-52684c02a091"
  }
  management_group_policy_assignment = var.management_group.id != null
  effect                             = "\"${var.effect}\""
  nsgRegion                          = "\"${var.nsgRegion}\""
  storageId                          = "\"${var.storageId}\""
  timeInterval                       = "\"${var.timeInterval}\""
  workspaceResourceId                = "\"${var.workspaceResourceId}\""
  workspaceRegion                    = "\"${var.workspaceRegion}\""
  workspaceId                        = "\"${var.workspaceId}\""
  networkWatcherRG                   = "\"${lower(var.networkWatcherRG)}\"" #lower to avoid resource replacement caused by capitalization
  networkWatcherName                 = "\"${var.networkWatcherName}\""
  display_name                       = local.management_group_policy_assignment ? "${var.effect} \"${local.policy_definition.name}\" for ${var.location} on ${var.management_group.name}" : ""
}


resource "azurerm_management_group_policy_assignment" "this" {

  count                = local.management_group_policy_assignment ? 1 : 0
  policy_definition_id = local.policy_definition.id
  name                 = substr("policy-${replace(uuidv5("oid", local.display_name), "-", "")}", 0, 24)
  management_group_id  = var.management_group.id
  not_scopes           = var.not_scopes
  identity {
    type = "SystemAssigned"
  }
  location     = var.location #The location field must be specified when identity is specified.
  description  = var.description
  display_name = local.display_name
  enforce      = var.enforce
  parameters   = <<PARAMETERS
    {
      "effect":
      {
        "value": ${local.effect}
      },
      "nsgRegion":
      {
        "value": ${local.nsgRegion}
      },
      "storageId":
      {
        "value": ${local.storageId}
      },
      "timeInterval":
      {
        "value": ${local.timeInterval}
      },
      "workspaceResourceId":
      {
        "value": ${local.workspaceResourceId}
      },
      "workspaceRegion":
      {
        "value": ${local.workspaceRegion}
      },
      "workspaceId":
      {
        "value": ${local.workspaceId}
      },
      "networkWatcherRG":
      {
        "value": ${local.networkWatcherRG}
      },
      "networkWatcherName":
      {
        "value": ${local.networkWatcherName}
      }
    }
    PARAMETERS
}

resource "azurerm_role_assignment" "management_group_policy_assignment" {

  count                = local.management_group_policy_assignment ? 1 : 0
  scope                = var.management_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this[count.index].identity[0].principal_id
}
