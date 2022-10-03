resource "azurerm_service_plan" "monlog" {
  provider = azurerm.sandbox

  name                = "plan-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  location            = module.info.primary_region.name
  sku_name            = "F1"
  os_type             = "Linux"
}


resource "azurerm_linux_web_app" "monlog" {
  provider = azurerm.sandbox

  name                = "app-${module.info.descriptive_context}-${module.info.sandbox.short_name}01"
  resource_group_name = data.terraform_remote_state.core.outputs.core_resource_group_name
  location            = module.info.primary_region.name
  service_plan_id     = azurerm_service_plan.monlog.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    always_on           = false
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.monlog.instrumentation_key
    "APPINSIGHTS_JAVASCRIPT_ENABLED"                  = "true"
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = azurerm_application_insights.monlog.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    "DiagnosticServices_EXTENSION_VERSION"            = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"         = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"              = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "XDT_MicrosoftApplicationInsights_Java"           = "1"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "XDT_MicrosoftApplicationInsights_NodeJS"         = "1"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"     = "disabled"
  }

    sticky_settings {
      app_setting_names = [
        "APPINSIGHTS_INSTRUMENTATIONKEY",
        "APPLICATIONINSIGHTS_CONNECTION_STRING ",
        "APPINSIGHTS_PROFILERFEATURE_VERSION",
        "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
        "ApplicationInsightsAgent_EXTENSION_VERSION",
        "XDT_MicrosoftApplicationInsights_BaseExtensions",
        "DiagnosticServices_EXTENSION_VERSION",
        "InstrumentationEngine_EXTENSION_VERSION",
        "SnapshotDebugger_EXTENSION_VERSION",
        "XDT_MicrosoftApplicationInsights_Mode",
        "XDT_MicrosoftApplicationInsights_PreemptSdk",
        "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
        "XDT_MicrosoftApplicationInsightsJava",
        "XDT_MicrosoftApplicationInsights_NodeJS",
      ]
    }

}


resource "azurerm_application_insights" "monlog" {
  provider = azurerm.sandbox

  name                                  = "appi-${module.info.descriptive_context}-${module.info.sandbox.short_name}01"
  location                              = module.info.primary_region.name
  resource_group_name                   = data.terraform_remote_state.core.outputs.core_resource_group_name
  application_type                      = "web"
  daily_data_cap_in_gb                  = 100
  daily_data_cap_notifications_disabled = false
  workspace_id                          = data.terraform_remote_state.core.outputs.core_log_analytics_workspace_id
}


resource "azurerm_app_service_source_control" "monlog" {
  provider = azurerm.sandbox

  app_id                 = azurerm_linux_web_app.monlog.id
  repo_url               = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch                 = "master"
  use_manual_integration = true
  use_mercurial          = false
}