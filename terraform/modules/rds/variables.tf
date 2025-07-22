variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "sg_id" {
  type = string
}

variable "create_replica" {
  type    = bool
  default = false
}

variable "source_db_arn" {
  type    = string
  default = ""
}
