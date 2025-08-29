data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.hub_rgname
    storage_account_name = var.tf_staccount
    container_name       = var.tf_container
    key                  = "${var.project}-${var.hub_env}-${var.hub_location_short}.tfstate"
  }
}
