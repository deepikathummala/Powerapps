module "resource_group" {
source = "./modules/resourcegroup"
rg_name  = var.rg_name 
location = var.location
create_rg_name = true
}
module "kv" {
source = "./modules/keyvault"
keyvault_name = var.keyvault_name
location = var.location
create_keyvault = true
tenant_id = "17563e80-c657-47ec-938e-b1b0ba5df9ec"
env = "dev"
rg_name  = var.rg_name
}
