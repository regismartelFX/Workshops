provider "azurerm" {

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = "id Subsription #1"
  tenant_id       = "tenant_id"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# provider "azurerm" {
#   alias           = "demo"
#   subscription_id = "id Subsription #2"
#   tenant_id       = "tenant_id"

#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }
# }

# override this file locally https://www.terraform.io/language/files/override