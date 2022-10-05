terraform {
  required_version = ">= 1.2.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23.0"
    }
    # azapi = {
    #   source  = "azure/azapi"
    #   version = "~> 0.6.0"
    # }
  }
}
