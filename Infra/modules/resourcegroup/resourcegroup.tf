resource "azurerm_resource_group" "rg" {
  count = var.rg_name ? 1 : 0
  name = var.rg_name
  location = var.location
}
