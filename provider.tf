# Configure the Azure provider, you can have many
# if you use azurerm provider, it's source is hashicorp/azurerm
# short for registry.terraform.io/hashicorp/azurerm


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.12.0"
    }
  }

  required_version = ">= 1.9.0"
}
# configures the provider

provider "azurerm" {
  subscription_id = "46b70d33-6052-422c-86a1-26fd1ebfc601"
  features {}
}
