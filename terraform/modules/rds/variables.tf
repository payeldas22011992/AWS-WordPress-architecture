variable "name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "sg_id" {}
variable "db_username" {}
variable "db_password" {}
variable "create_replica" {
  type    = bool
  default = false
}
variable "source_db_arn" {
  type    = string
  default = ""
}
