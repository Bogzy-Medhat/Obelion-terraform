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
  
  // Update this section to include subnets from at least two different AZs
  subnet_ids = [
      "subnet-0aa45b5e06618eb39", // Existing subnet
      "subnet-0cb1142b009c0b93d", // Existing subnet
      "subnet-02f5b39ff32abacee", // Add another subnet from a different AZ
      "subnet-086208d0f78f43ec1"  // Add another subnet from a different AZ
  ]

  tags = {
    Name = "mydb-subnet-group"
  }
}

output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}
