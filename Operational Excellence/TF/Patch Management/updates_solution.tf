

# resource "azurerm_resource_group" "rg" {

#   name     = "rg-updtest-t01"
#   location = local.location
# }

# resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {

#   name                = "log-updtest-t01"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# resource "azurerm_automation_account" "automation_account" {

#   name                = "aa-updtest-t01"
#   location            = local.automation_account_location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "Basic"

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_role_assignment" "contributor" {

#   scope                = "/subscriptions/98bdc428-ae8c-413a-b970-c9d152a17ced"
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_automation_account.automation_account.identity[0].principal_id
# }

# resource "azurerm_log_analytics_linked_service" "autoacc_linked_log_workspace" {

#   resource_group_name = azurerm_resource_group.rg.name
#   workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
#   read_access_id      = azurerm_automation_account.automation_account.id
# }

# resource "azurerm_log_analytics_solution" "update_solution" {

#   depends_on = [
#     azurerm_log_analytics_linked_service.autoacc_linked_log_workspace
#   ]

#   solution_name         = "Updates"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
#   workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name
#   plan {
#     publisher = "Microsoft"
#     product   = "OMSGallery/Updates"
#   }
# }

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
