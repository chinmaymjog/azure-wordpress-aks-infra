terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.27.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
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

provider "tls" {
}