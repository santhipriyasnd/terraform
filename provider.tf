provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "395b2b6c-8fb6-4cc1-83e4-39455be6b102"
  client_id       = "df4415d0-e7a2-4334-9d5c-fa45d42eaeee"
  client_secret   = "8~pdhCQUZ~yMTP_M-hCK1imb~AO22L1.wn"
  tenant_id       = "90c3f360-0a02-49e4-b70c-4ebb69378edf"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "k8st"
    container_name       = "container3"
    key                  = "dev.terraform.tfstate"
    access_key = "hvdqCgGitXMMcumfAAAjl6C4J6raPQbo/LcFdBwH/LuiMYpiQxx88xyduy9BRy0MwUmowTIFOqFs1Wl+pRJ02w=="
  }
}