provider "azurerm" {

  features {}
}

provider "azurerm" {
  alias           = "demo_1"
  subscription_id = "id Subsription #1"
  tenant_id       = "tenant_id"

  features {}
}

# provider "azurerm" {
#   alias           = "demo_2"
#   subscription_id = "id Subsription #2"
#   tenant_id       = "tenant_id"

#   features {}
# }

# override this file locally https://www.terraform.io/language/files/override