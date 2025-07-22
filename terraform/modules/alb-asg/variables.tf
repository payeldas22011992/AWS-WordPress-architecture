variable "name" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "sg_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "user_data_vars" {
  type = map(string)
}
