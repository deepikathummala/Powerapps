resource "azurerm_key_vault" "kv" {
  count = var.create_keyvault ? 1:0
  name = var.keyvault_name
  location = var.location
  sku_name = "standard"
  tenant_id = var.tenant_id
  enabled_for_deployment = false
  enabled_for_disk_encryption = false
  enabled_for_template_deployment = true
  public_network_access_enabled = false
  purge_protection_enabled = false
  soft_delete_retention_days = 7
  resource_group_name = var.rg_name
  tags = { 
    environmrnt = var.env
  } 
  network_acls {
     default_action = "Allow"
     bypass = "AzureServices"
     ip_rules = []
     virtual_network_subnet_ids = []
  }
}
