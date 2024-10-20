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
  description = "Managed by Terraform"
  
  subnet_ids = aws_subnet.my_subnet[*].id // Reference the created subnets

  tags = {
    Name = "mydb-subnet-group"
  }
}

resource "aws_subnet" "my_subnet" {
  count = 4 // Create 4 subnets
  vpc_id = var.vpc_id // Ensure you have a variable for your VPC ID
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index) // Adjust CIDR as needed
  availability_zone = element(data.aws_availability_zones.available.names, count.index) // Use different AZs

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
