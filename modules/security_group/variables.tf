variable "name" {
  description = "The name of the security group"
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
}

variable "ingress_rules" {
  description = "A list of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}