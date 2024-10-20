resource "aws_instance" "backend" {
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
    Name = "backend-machine"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ${var.username} // Use the correct variable for the username
              sudo apt install -y composer // Added Composer installation
              curl -sS https://getcomposer.org/installer | php // Download Composer
              sudo mv composer.phar /usr/local/bin/composer // Move Composer to bin
              sudo add-apt-repository ppa:ondrej/php // Add PHP repository
              sudo apt update // Update package list again
              sudo apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-mbstring php8.2-xml php8.2-curl php8.2-bcmath // Install PHP packages
              EOF
}

output "public_ip" {
  value = aws_instance.backend.public_ip
}

output "instance_id" {
  value = aws_instance.backend.id
}

variable "username" {
  description = "The username to be added to the Docker group"
  type        = string
}
