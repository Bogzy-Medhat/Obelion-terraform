variable "db_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "db_username" {
  description = "The username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  sensitive   = true
  default     = "password123"
}

variable "security_group_id" {
  description = "The security group ID for the RDS instance"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
  default     = [] // Leave this empty for now; it will be populated dynamically
}
