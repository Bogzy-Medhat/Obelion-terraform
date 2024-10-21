resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name // Ensure this variable is defined in variables.tf
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index) # Ensure this is properly referencing subnet IDs
  route_table_id = aws_route_table.public.id
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

