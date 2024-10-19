variable "name" {
  description = "The name of the security group"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
}

# ```modules/security_group/variables.tf
variable "ingress_rules" {
  description = "A list of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string) // This should contain valid CIDR blocks
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // Example CIDR block for HTTP
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24"] // Example CIDR block for SSH
    }
  ]
}
