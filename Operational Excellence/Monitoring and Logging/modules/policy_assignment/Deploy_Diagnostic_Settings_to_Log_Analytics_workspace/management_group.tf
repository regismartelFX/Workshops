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
    name = "Deploy Diagnostic Settings to Log Analytics workspace"
    id   = var.policy_definition_id
  }
  management_group_policy_assignment = var.management_group.id != null
  logAnalytics                       = "\"${lower(var.logAnalytics)}\""
  effect                             = "\"${var.effect}\""
  profileName                        = "\"${var.profileName}\""
  metricsEnabled                     = "\"${title(tostring(var.metricsEnabled))}\"" #title() to avoid "The value 'true' is not allowed for policy parameter '' in policy definition ''. The allowed values are 'True, False'."
  logsEnabled                        = "\"${title(tostring(var.logsEnabled))}\""    #title() to avoid "The value 'true' is not allowed for policy parameter '' in policy definition ''. The allowed values are 'True, False'."
  display_name                       = local.management_group_policy_assignment ? "Initiative \"${local.policy_definition.name}\" on ${var.management_group.name}" : ""
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
      "logAnalytics":
      {
        "value": ${local.logAnalytics}
      },
      "effect":
      {
        "value": ${local.effect}
      },
      "profileName":
      {
        "value": ${local.profileName}
      },
      "metricsEnabled":
      {
        "value": ${local.metricsEnabled}
      },
      "logsEnabled":
      {
        "value": ${local.logsEnabled}
      }
    }
    PARAMETERS
}


resource "azurerm_role_assignment" "management_group_policy_assignment_MonitoringContributor" {

  count                = local.management_group_policy_assignment ? 1 : 0
  scope                = var.management_group.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this[count.index].identity[0].principal_id
}


resource "azurerm_role_assignment" "management_group_policy_assignment_LogAnalyticsContributor" {

  count                = local.management_group_policy_assignment ? 1 : 0
  scope                = var.management_group.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this[count.index].identity[0].principal_id
}
