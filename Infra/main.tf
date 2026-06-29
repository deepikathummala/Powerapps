module "resource_group" {
source = "./modules/resourcegroup"
rg_name  = var.rg_name 
location = var.location
create_rg_name = var.create_rg_name
}
module "kv" {
count = var.create_keyvault ? 1 : 0
source = "./modules/keyvault"
keyvault_name = var.keyvault_name
location = var.location
create_keyvault = var.create_keyvault
tenant_id = "17563e80-c657-47ec-938e-b1b0ba5df9ec"
env = "dev"
rg_name  = var.rg_name
}
module "functionapp" {
count = var.create_func ? 1 : 0
source = "./modules/functionapp"
func_name = var.func_name
rg_name  = var.rg_name 
location = var.location
appserviceplan_name = var.appserviceplan_name
appinsghts_name = var.appinsghts_name
st_name = var.st_name
env = var.env
}

