provider "azurerm" {

  features {}
}

provider "azurerm" {
  alias           = "sandbox"
  subscription_id = "id Subsription #1"
  tenant_id       = "tenant_id"

  features {}
}

# provider "azurerm" {
#   alias           = "demo"
#   subscription_id = "id Subsription #2"
#   tenant_id       = "tenant_id"

#   features {}
# }

# override this file locally https://www.terraform.io/language/files/override