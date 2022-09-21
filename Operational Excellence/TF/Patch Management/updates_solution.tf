resource "azurerm_log_analytics_linked_service" "demo" {
  provider = azurerm.demo_1

  resource_group_name = data.azurerm_resource_group.demo.name
  workspace_id        = data.azurerm_log_analytics_workspace.demo.id
  read_access_id      = data.azurerm_automation_account.demo.id
}

resource "azurerm_log_analytics_solution" "update_solution" {
  provider = azurerm.demo_1

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

# resource "azapi_resource" "demoa" {
#   type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
#   name      = "Demo A"
#   parent_id = azurerm_automation_account.automation_account.id

#   body = jsonencode({
#     properties = {
#       scheduleInfo = {
#         description             = null
#         startTime               = "2022-07-20T11:00:00-04:00"
#         expiryTime              = "9999-12-31T18:59:00-05:00"
#         expiryTimeOffsetMinutes = -300
#         isEnabled               = true
#         interval                = 1
#         frequency               = "Hour"
#         timeZone                = "America/Toronto" #"Eastern Standard Time"
#       }
#       tasks = {
#         postTask = null
#         preTask  = null
#       }
#       updateConfiguration = {
#         duration        = "PT1H"
#         operatingSystem = "Windows"
#         linux           = null
#         windows = {
#           excludedKbNumbers             = []
#           includedKbNumbers             = []
#           includedUpdateClassifications = "Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, Updates"
#           rebootSetting                 = "Always"
#         }
#         azureVirtualMachines  = []
#         nonAzureComputerNames = []
#         targets = {
#           azureQueries = [
#             {
#               locations = []
#               scope = [
#                 "/subscriptions/98bdc428-ae8c-413a-b970-c9d152a17ced",
#                 "/subscriptions/bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
#               ]
#               tagSettings : {
#                 filterOperator : "All"
#                 tags : {
#                   "patchingpolicy" : ["A"]
#                 }
#               }
#             }
#           ]
#           nonAzureQueries = null
#         }
#       }
#     }
#   })
# }

# resource "azapi_resource" "democ" {
#   type      = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations@2019-06-01"
#   name      = "Demo C"
#   parent_id = azurerm_automation_account.automation_account.id

#   body = jsonencode({
#     properties = {
#       scheduleInfo = {
#         description             = null
#         startTime               = "2022-07-20T11:00:00-04:00"
#         expiryTime              = "9999-12-31T18:59:00-05:00"
#         expiryTimeOffsetMinutes = -300
#         isEnabled               = true
#         interval                = 1
#         frequency               = "Hour"
#         timeZone                = "America/Toronto" #"Eastern Standard Time"
#       }
#       tasks = {
#         postTask = null
#         preTask  = null
#       }
#       updateConfiguration = {
#         duration        = "PT1H"
#         operatingSystem = "Windows"
#         linux           = null
#         windows = {
#           excludedKbNumbers             = []
#           includedKbNumbers             = []
#           includedUpdateClassifications = "Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, Updates"
#           rebootSetting                 = "Always"
#         }
#         azureVirtualMachines  = []
#         nonAzureComputerNames = []
#         targets = {
#           azureQueries = [
#             {
#               locations = []
#               scope = [
#                 "/subscriptions/98bdc428-ae8c-413a-b970-c9d152a17ced",
#                 "/subscriptions/bcd14a1b-f207-4552-a1da-f33f5efe4b2e"
#               ]
#               tagSettings : {
#                 filterOperator : "All"
#                 tags : {
#                   "patchingpolicy" : ["C"]
#                 }
#               }
#             }
#           ]
#           nonAzureQueries = null
#         }
#       }
#     }
#   })
# }
