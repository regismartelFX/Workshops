terraform {
  backend "azurerm" {
    resource_group_name  = "resource_group_name"
    storage_account_name = "storage_account_name"
    container_name       = "container_name"
    key                  = "key.terraform.tfstate"
  }
}

# override this file locally https://www.terraform.io/language/files/override