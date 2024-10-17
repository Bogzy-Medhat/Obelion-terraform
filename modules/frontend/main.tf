resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size = 8
  }

  associate_public_ip_address = true

  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  tags = {
    Name = "frontend-machine"
  }
}

output "public_ip" {
  value = aws_instance.frontend.public_ip
}

output "instance_id" {
  value = aws_instance.frontend.id
}