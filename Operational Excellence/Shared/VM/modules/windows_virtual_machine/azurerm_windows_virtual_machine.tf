data "azurerm_resource_group" "stdiag" {

  name = var.stdiag_resource_group_name
}


data "azurerm_storage_account" "stdiag" {

  name                = var.stdiag_name
  resource_group_name = data.azurerm_resource_group.stdiag.name
}


data "azurerm_resource_group" "core" {

  name = var.core_resource_group_name
}


data "azurerm_key_vault" "core" {

  name                = var.core_key_vault_name
  resource_group_name = data.azurerm_resource_group.core.name
}


data "azurerm_key_vault_secret" "admin" {

  name         = var.core_key_vault_admin_secret_name
  key_vault_id = data.azurerm_key_vault.core.id
}


data "azurerm_key_vault_secret" "adminpwd" {

  name         = var.core_key_vault_adminpwd_secret_name
  key_vault_id = data.azurerm_key_vault.core.id
}


data "azurerm_virtual_network" "core" {

  name                = var.core_virtual_network_name
  resource_group_name = data.azurerm_resource_group.core.name
}


data "azurerm_subnet" "core" {

  name                 = var.core_subnet_name
  virtual_network_name = data.azurerm_virtual_network.core.name
  resource_group_name  = data.azurerm_resource_group.core.name
}


data "azurerm_log_analytics_workspace" "core" {

  name                = var.core_log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.core.name
}


resource "azurerm_resource_group" "vm" {
  count = var.quantity

  name     = format("rg-vm${var.descriptive_context}-${var.environment}%02s", count.index + var.seed)
  location = var.location
}


resource "azurerm_network_interface" "vm" {
  count = var.quantity

  name                = format("vm-${var.descriptive_context}-${var.environment}%02s-nic01", count.index + var.seed)
  location            = var.location
  resource_group_name = azurerm_resource_group.vm[count.index].name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.azurerm_subnet.core.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_windows_virtual_machine" "vm" {
  count = var.quantity

  name                = format("vm-${var.descriptive_context}-${var.environment}%02s", count.index + var.seed)
  resource_group_name = azurerm_resource_group.vm[count.index].name
  location            = var.location
  size                = var.size
  admin_username      = data.azurerm_key_vault_secret.admin.value
  admin_password      = data.azurerm_key_vault_secret.adminpwd.value
  provision_vm_agent  = true
  network_interface_ids = [
    azurerm_network_interface.vm[count.index].id,
  ]
  tags = { for i, v in var.tags : i => element(v, count.index) }
  zone = var.deploy_to_availability_zone ? ((count.index + var.seed) % 3) + 1 : null

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.stdiag.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    name                 = format("vm-${var.descriptive_context}-${var.environment}%02s-disk-os-01", count.index + var.seed)
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}


resource "azurerm_virtual_machine_extension" "mma" {
  count = var.quantity

  name = "${azurerm_windows_virtual_machine.vm[count.index].name}-mma"

  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  virtual_machine_id = azurerm_windows_virtual_machine.vm[count.index].id

  settings = <<SETTINGS
  {
    "workspaceId": "${data.azurerm_log_analytics_workspace.core.workspace_id}"
  }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "workspaceKey": "${data.azurerm_log_analytics_workspace.core.primary_shared_key}"
  }
PROTECTED_SETTINGS
}


data "azurerm_managed_disk" "vm" {
  count = var.quantity

  name                = format("vm-${var.descriptive_context}-${var.environment}%02s-disk-os-01", count.index + var.seed)
  resource_group_name = azurerm_resource_group.vm[count.index].name

  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]
}