terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.15"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.99.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
}
