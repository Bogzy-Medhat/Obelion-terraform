resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  engine_version       = "8.0"
  db_name              = "mydb"
  username             = "admin"
  password             = "password123"
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = {
    Name = "mysql-db"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "mydb-subnet-group"
  subnet_ids = [
    "subnet-089575b2352e5438a",
    "subnet-0b0f7c4737a2e2ddf",
    "subnet-0af8e27f50c2ab2da",
    "subnet-09067cf25afbed04b"
  ]
  description = "Managed by Terraform"
  tags = {
    Name = "mydb-subnet-group"
  }
}

resource "aws_subnet" "my_subnet" {
  count = 2 # Use the actual subnet count if only two public subnets are used
  vpc_id = var.vpc_id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "mydb-subnet-${count.index}"
  }
}


output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}

// Add this data resource declaration
data "aws_availability_zones" "available" {}

variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
}
