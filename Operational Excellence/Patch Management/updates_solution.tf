data "azurerm_subscription" "sandbox" {
  provider = azurerm.sandbox
}


resource "azurerm_log_analytics_linked_service" "patchmanagement" {
  provider = azurerm.sandbox

  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  workspace_id        = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
  read_access_id      = data.terraform_remote_state.core.outputs.core_automation_account_id
}

resource "azurerm_log_analytics_solution" "updates" {
  provider = azurerm.sandbox

  solution_name         = "Updates"
  location              = module.info.primary_region.name
  resource_group_name   = data.terraform_remote_state.core.outputs.core_resource_group_name
  workspace_resource_id = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
  workspace_name        = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }

  depends_on = [
    azurerm_log_analytics_linked_service.patchmanagement
  ]
}

resource "azapi_resource" "windows_group_a" {
  type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
  name      = "Windows Group A"
  parent_id = data.terraform_remote_state.core.outputs.core_automation_account_id

  body = jsonencode({
    properties = {
      scheduleInfo = {
        description             = null
        startTime               = timeadd(timestamp(), "10m") #"2022-09-21T17:00:00-04:00"
        expiryTime              = "9999-12-31T18:59:00-05:00"
        expiryTimeOffsetMinutes = -300
        isEnabled               = true
        interval                = 1
        frequency               = "Hour"
        timeZone                = "America/Toronto" #"Eastern Standard Time"
      }
      tasks = {
        postTask = null
        preTask  = null
      }
      updateConfiguration = {
        duration        = "PT1H"
        operatingSystem = "Windows"
        linux           = null
        windows = {
          excludedKbNumbers             = []
          includedKbNumbers             = []
          includedUpdateClassifications = "Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, Updates"
          rebootSetting                 = "Always"
        }
        azureVirtualMachines  = []
        nonAzureComputerNames = []
        targets = {
          azureQueries = [
            {
              locations = []
              scope = [
                data.azurerm_subscription.sandbox.id
              ]
              tagSettings : {
                filterOperator : "All"
                tags : {
                  "PatchingPolicy" : ["Windows Group A"]
                }
              }
            }
          ]
          nonAzureQueries = null
        }
      }
    }
  })
}


resource "azapi_resource" "windows_group_b" {
  type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
  name      = "Windows Group B"
  parent_id = data.terraform_remote_state.core.outputs.core_automation_account_id

  body = jsonencode({
    properties = {
      scheduleInfo = {
        description             = null
        startTime               = timeadd(timestamp(), "10m") #"2022-09-21T17:00:00-04:00"
        expiryTime              = "9999-12-31T18:59:00-05:00"
        expiryTimeOffsetMinutes = -300
        isEnabled               = true
        interval                = 1
        frequency               = "Hour"
        timeZone                = "America/Toronto" #"Eastern Standard Time"
      }
      tasks = {
        postTask = null
        preTask  = null
      }
      updateConfiguration = {
        duration        = "PT1H"
        operatingSystem = "Windows"
        linux           = null
        windows = {
          excludedKbNumbers             = []
          includedKbNumbers             = []
          includedUpdateClassifications = "Critical, Security, UpdateRollup"
          rebootSetting                 = "Never"
        }
        azureVirtualMachines  = []
        nonAzureComputerNames = []
        targets = {
          azureQueries = [
            {
              locations = []
              scope = [
                data.azurerm_subscription.sandbox.id
              ]
              tagSettings : {
                filterOperator : "All"
                tags : {
                  "PatchingPolicy" : ["Windows Group B"]
                }
              }
            }
          ]
          nonAzureQueries = null
        }
      }
    }
  })
}


resource "azapi_resource" "linux_group_a" {
  type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
  name      = "Linux Group A"
  parent_id = data.terraform_remote_state.core.outputs.core_automation_account_id

  body = jsonencode({
    properties = {
      scheduleInfo = {
        description             = null
        startTime               = timeadd(timestamp(), "10m") #"2022-09-21T17:00:00-04:00"
        expiryTime              = "9999-12-31T18:59:00-05:00"
        expiryTimeOffsetMinutes = -300
        isEnabled               = true
        interval                = 1
        frequency               = "Hour"
        timeZone                = "America/Toronto" #"Eastern Standard Time"
      }
      tasks = {
        postTask = null
        preTask  = null
      }
      updateConfiguration = {
        duration        = "PT1H"
        operatingSystem = "Linux"
        windows           = null
        linux = {
          excludedPackageNameMasks             = []
          includedPackageNameMasks              = []
          includedPackageClassifications  = "Critical, Security, Other"
          rebootSetting                 = "IfRequired"
        }
        azureVirtualMachines  = []
        nonAzureComputerNames = []
        targets = {
          azureQueries = [
            {
              locations = []
              scope = [
                data.azurerm_subscription.sandbox.id
              ]
              tagSettings : {
                filterOperator : "All"
                tags : {
                  "PatchingPolicy" : ["Linux Group A"]
                }
              }
            }
          ]
          nonAzureQueries = null
        }
      }
    }
  })
}
