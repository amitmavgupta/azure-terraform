terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  alias                      = "test"
}

resource "azurerm_resource_provider_registration" "AzureLinux" {
  name = "Microsoft.ContainerService"
  feature {
    name       = "AzureLinuxV3Preview"
    registered = true
  }
}