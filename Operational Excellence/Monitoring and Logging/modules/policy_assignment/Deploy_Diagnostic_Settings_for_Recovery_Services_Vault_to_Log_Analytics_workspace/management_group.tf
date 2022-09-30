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
    name = "Deploy Diagnostic Settings for Recovery Services Vault to Log Analytics workspace" #"Deploy Diagnostic Settings for Recovery Services Vault to Log Analytics workspace for resource specific categories" shorthened to avoid "...display name exceeded the allowed length limit" errors
    id   = "/providers/Microsoft.Authorization/policyDefinitions/c717fb0c-d118-4c43-ab3d-ece30ac81fb3"
  }
  management_group_policy_assignment = var.management_group.id != null
  logAnalytics                       = "\"${lower(var.logAnalytics)}\""
  profileName                        = "\"${var.profileName}\""
  effect                             = "DeployIfNotExists" #fixed  
  display_name                       = local.management_group_policy_assignment ? "${local.effect} \"${local.policy_definition.name}\" for ${var.location} on ${var.management_group.name}" : ""
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
      "profileName":
      {
        "value": ${local.profileName}
      }
    }
    PARAMETERS
}


resource "azurerm_role_assignment" "management_group_policy_assignment_log_analytics_contributor" {

  count                = local.management_group_policy_assignment ? 1 : 0
  scope                = var.management_group.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this[count.index].identity[0].principal_id
}


resource "azurerm_role_assignment" "management_group_policy_assignment_monitoring_contributor" {

  count                = local.management_group_policy_assignment ? 1 : 0
  scope                = var.management_group.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this[count.index].identity[0].principal_id
}
