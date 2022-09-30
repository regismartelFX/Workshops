resource "azurerm_policy_set_definition" "this" {
  name                = "Deploy_Diagnostic_Settings_to_Log_Analytics_workspace"
  policy_type         = "Custom"
  display_name        = "Deploy Diagnostic Settings to Log Analytics workspace"
  management_group_id = var.management_group_id == "" ? null : var.management_group_id

  parameters = <<PARAMETERS
{
  "logAnalytics": {
    "type": "String",
    "metadata": {
      "displayName": "Log Analytics workspace",
      "description": "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.",
      "strongType": "omsWorkspace"
    }
  },
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    },
    "allowedValues": [
      "DeployIfNotExists",
      "Disabled"
    ],
    "defaultValue": "DeployIfNotExists"
  },
  "profileName": {
    "type": "String",
    "metadata": {
      "displayName": "Profile name",
      "description": "The diagnostic settings profile name"
    },
    "defaultValue": "setbypolicy"
  },
  "metricsEnabled": {
    "type": "String",
    "metadata": {
      "displayName": "Enable metrics",
      "description": "Whether to enable metrics stream to the Log Analytics workspace - True or False"
    },
    "allowedValues": [
      "True",
      "False"
    ],
    "defaultValue": "True"
  },
  "logsEnabled": {
    "type": "String",
    "metadata": {
      "displayName": "Enable logs",
      "description": "Whether to enable logs stream to the Log Analytics workspace - True or False"
    },
    "allowedValues": [
      "True",
      "False"
    ],
    "defaultValue": "True"
  }
}
PARAMETERS

  dynamic "policy_definition_reference" {
    for_each = var.definition_references

    content {
      policy_definition_id = policy_definition_reference.key
      parameter_values     = <<PARAMETER_VALUES
{
  "logAnalytics": {"value": "[parameters('logAnalytics')]"},
  "effect": {"value": "[parameters('effect')]"},
  "profileName": {"value": "[parameters('profileName')]"},
  "metricsEnabled": {"value": "[parameters('metricsEnabled')]"},
  "logsEnabled": {"value": "[parameters('logsEnabled')]"}
}
PARAMETER_VALUES
    }
  }
}
