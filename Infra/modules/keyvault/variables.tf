variable "keyvault_name" {
  type = string
}
variable "env" {
  type = string 
}
variable "location" {
  type = string
  default = "eastus"
}
variable "tenant_id" {
  type = string
  default = ""
}
variable "rg_name" {
  type = string
}
