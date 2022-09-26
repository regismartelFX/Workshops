resource "azurerm_recovery_services_vault" "demo" {
  provider = azurerm.sandbox

  name                = "rsv-${module.info.descriptive_context}-${module.info.primary_region.code}-${module.info.sandbox.short_name}01"
  resource_group_name = data.azurerm_resource_group.demo.name
  location            = module.info.primary_region.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
  soft_delete_enabled = true

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_backup_policy_vm" "demo_daily" {
  provider = azurerm.sandbox

  name                = "DEMO-35d-12m-7y"
  resource_group_name = data.azurerm_resource_group.demo.name
  recovery_vault_name = azurerm_recovery_services_vault.demo.name

  timezone                       = "Eastern Standard Time"
  instant_restore_retention_days = 2

  backup {
    frequency = "Daily"
    time      = "02:00"
  }

  retention_daily {
    count = 35
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count    = 7
    weekdays = ["Sunday"]
    weeks    = ["First"]
    months   = ["January"]
  }
}


resource "azurerm_backup_policy_vm_workload" "demo_sql_daily" {
  provider = azurerm.sandbox

  name                = "SQLFullDaily"
  resource_group_name = data.azurerm_resource_group.demo.name
  recovery_vault_name = azurerm_recovery_services_vault.demo.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = "Eastern Standard Time"
    compression_enabled = true
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Daily"
      time      = "19:30"
      weekdays  = []
    }

    retention_daily {
      count = 7
    }
  }
}