module "resource_group" {
source = "./modules/resourcegroup"
rg_name  = var.rg_name 
location = var.location
create_rg_name = true
}
