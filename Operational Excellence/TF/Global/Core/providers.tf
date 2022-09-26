provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = "id Subsription #1"
  tenant_id       = "tenant_id"

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# provider "azurerm" {
#   alias           = "demo_2"
#   subscription_id = "id Subsription #2"
#   tenant_id       = "tenant_id"

#   features {}
# }

# override this file locally https://www.terraform.io/language/files/override