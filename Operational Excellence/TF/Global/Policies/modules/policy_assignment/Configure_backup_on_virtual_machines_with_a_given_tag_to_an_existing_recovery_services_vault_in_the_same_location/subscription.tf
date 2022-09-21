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
    name = "Configure backup on VM with a given tag to an existing RSV in the same location" #Original name is "Configure backup on virtual machines with a given tag to an existing recovery services vault in the same location" but display name exceeds the 128 limit character if used unabbreviated.
    id   = "/providers/Microsoft.Authorization/policyDefinitions/345fa903-145c-4fe1-8bcd-93ec2adccde8"
  }
  subscription_policy_assignment = var.subscription.id != null
  effect                         = "\"${var.effect}\""
  vaultLocation                  = "\"${var.vaultLocation}\""
  inclusionTagName               = "\"${var.inclusionTagName}\""
  backupPolicyId                 = "\"${var.backupPolicyId}\""
  display_name                   = local.subscription_policy_assignment ? "${var.effect} \"${local.policy_definition.name}\" on ${var.subscription.name}" : ""
  separator                      = "\", \""
  formattedInclusionTagValue     = "[\"${join(local.separator, var.inclusionTagValue)}\"]"
}


resource "azurerm_subscription_policy_assignment" "this" {

  count                = local.subscription_policy_assignment ? 1 : 0
  policy_definition_id = local.policy_definition.id
  name                 = substr("policy-${replace(uuidv5("oid", local.display_name), "-", "")}", 0, 64)
  subscription_id      = var.subscription.id
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
      "vaultLocation":
      {
        "value": ${local.vaultLocation}
      },
      "inclusionTagName":
      {
        "value": ${local.inclusionTagName}
      },
      "inclusionTagValue":
      {
        "value": ${local.formattedInclusionTagValue}
      },
      "backupPolicyId":
      {
        "value": ${local.backupPolicyId}
      },
      "effect":
      {
        "value": ${local.effect}
      }
    }
    PARAMETERS
}


resource "azurerm_role_assignment" "subscription_policy_assignment_VirtualMachineContributor" {

  count                = local.subscription_policy_assignment ? 1 : 0
  scope                = var.subscription.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_subscription_policy_assignment.this[count.index].identity[0].principal_id
}


resource "azurerm_role_assignment" "subscription_policy_assignment_BackupContributor" {

  count                = local.subscription_policy_assignment ? 1 : 0
  scope                = var.subscription.id
  role_definition_name = "Backup Contributor"
  principal_id         = azurerm_subscription_policy_assignment.this[count.index].identity[0].principal_id
}
