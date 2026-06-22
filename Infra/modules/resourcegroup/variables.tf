variable "rg_name" {
  type = string
}
variable "location" {
  type = string
  default = "eastus"
}
variable "create_rg_name" {
  type = bool
  default = false
}
