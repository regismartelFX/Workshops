terraform {
  required_version = ">= 1.2.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
  }
}


locals {
  policy_definition = {
    name = "Enable Azure Monitor for Virtual Machine Scale Sets"
    id   = "/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad"
  }
  management_group_policy_assignment      = var.management_group.id != null
  logAnalytics_1                          = "\"${lower(var.logAnalytics_1)}\"" #lower to avoid resource replacement caused by capitalization
  separator                               = "\", \""
  formattedListOfImageIdToInclude_windows = length(var.listOfImageIdToInclude_windows) > 0 ? "[\"${join(local.separator, var.listOfImageIdToInclude_windows)}\"]" : "[]"
  formattedListOfImageIdToInclude_linux   = length(var.listOfImageIdToInclude_linux) > 0 ? "[\"${join(local.separator, var.listOfImageIdToInclude_linux)}\"]" : "[]"
  display_name                            = local.management_group_policy_assignment ? "Initiative \"${local.policy_definition.name}\" on ${var.management_group.name}" : ""
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
      "logAnalytics_1":
      {
        "value": ${local.logAnalytics_1}
      },
      "listOfImageIdToInclude_windows":
      {
        "value": ${local.formattedListOfImageIdToInclude_windows}
      },
      "listOfImageIdToInclude_linux":
      {
        "value": ${local.formattedListOfImageIdToInclude_linux}
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
