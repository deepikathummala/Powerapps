variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}
variable "location" {
  description = "Azure Region"
  type        = string
}
variable "create_rg_name" {
  type = bool
}
variable "keyvault_name" {
  type = string
}
variable "env" {
  type = string 
}
variable "tenant_id" {
  type = string
}
variable "create_keyvault" { 
  type    = bool
  default = false
 }
variable "func_name" {
  type = string
}
variable "appinsghts_name" {
  type = string 
}
variable "appserviceplan_name" {
  type = string
}
variable "st_name" {
  type = string
}
variable "create_func" {
type =  bool
}
