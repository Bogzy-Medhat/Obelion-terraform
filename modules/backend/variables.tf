variable "ami_id" {
  description = "The AMI ID for the backend instance"
}

variable "instance_type" {
  description = "The instance type for the backend instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name for SSH access"
}

variable "security_group_id" {
  description = "The security group ID for the backend instance"
}

variable "subnet_id" {
  description = "The subnet ID for the backend instance"
}