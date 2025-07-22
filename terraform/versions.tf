variable "key_name" {
  type        = string
  description = "Name of the existing EC2 key pair for SSH access"
}

variable "db_user" {
  type        = string
  description = "Master username for the RDS database"
}

variable "db_password" {
  type        = string
  description = "Master password for the RDS database"
  sensitive   = true
}

variable "db_name" {
  type        = string
  default     = "wordpress"
  description = "Database name for WordPress"
}

variable "blocked_countries" {
  type        = list(string)
  description = "List of ISO country codes to block via WAF"
  default     = ["RU", "KP", "IR"]
}

variable "rds_primary_arn" {
  type        = string
  description = "Primary RDS ARN (used for replica)"
  default     = ""
}
