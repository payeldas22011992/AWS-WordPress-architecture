variable "name" {}
variable "alb_dns_name" {}
variable "blocked_countries" {
  type = list(string)
}
