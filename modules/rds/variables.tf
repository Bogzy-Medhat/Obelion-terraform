variable "db_name" {
  description = "The name of the database"
}

variable "db_username" {
  description = "The username for the database"
}

variable "db_password" {
  description = "The password for the database"
  sensitive   = true
}

variable "security_group_id" {
  description = "The security group ID for the RDS instance"
}

variable "subnet_ids" {
  description = "The subnet IDs for the RDS instance"
  type        = list(string)
}