variable "ami_id" {
  description = "The AMI ID for the frontend instance"
}

variable "instance_type" {
  description = "The instance type for the frontend instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name for SSH access"
}

variable "security_group_id" {
  description = "The security group ID for the frontend instance"
}

variable "subnet_id" {
  description = "The subnet ID for the frontend instance"
}
variable "username" {
  description = "The username to be added to the Docker group"
  type        = string
}
