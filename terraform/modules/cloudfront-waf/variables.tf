variable "name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "blocked_countries" {
  type = list(string)
  default = ["RU", "KP", "IR"] # Example: block Russia, North Korea, Iran
}
