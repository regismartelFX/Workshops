resource "azurerm_log_analytics_linked_service" "demo" {
  provider = azurerm.sandbox

  resource_group_name = data.azurerm_resource_group.demo.name
  workspace_id        = data.azurerm_log_analytics_workspace.demo.id
  read_access_id      = data.azurerm_automation_account.demo.id
}

resource "azurerm_log_analytics_solution" "update_solution" {
  provider = azurerm.sandbox

  solution_name         = "Updates"
  location              = module.info.primary_region.name
  resource_group_name   = data.azurerm_resource_group.demo.name
  workspace_resource_id = data.azurerm_log_analytics_workspace.demo.id
  workspace_name        = data.azurerm_log_analytics_workspace.demo.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }

  depends_on = [
    azurerm_log_analytics_linked_service.demo
  ]
}

resource "azapi_resource" "windows_group_a" {
  type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
  name      = "Windows Group A"
  parent_id = data.azurerm_automation_account.demo.id

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
  parent_id = data.azurerm_automation_account.demo.id

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
