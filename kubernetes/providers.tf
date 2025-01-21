terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.17.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.27.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}

provider "azuread" {
}