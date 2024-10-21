provider "aws" {
  region = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.32.0/24", "10.0.33.0/24"] // Added default value
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = "10.0.0.0/16"
  vpc_name            = "my-vpc"
  public_subnet_cidrs = var.public_subnet_cidrs
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block // Ensure this line correctly references the output
}

module "backend_sg" {
  source = "./modules/security_group"
  name   = "backend-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "frontend_sg" {
  source = "./modules/security_group"
  name   = "frontend-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
module "backend" {
  source            = "./modules/backend"
  ami_id            = "ami-005fc0f236362e99f"
  key_name          = "Obelion_task"
  instance_type     = "t2.micro"
  security_group_id = module.backend_sg.id
  subnet_id         = element(module.vpc.public_subnet_ids, 0)
  username          = "ubuntu"
}

module "frontend" {
  source            = "./modules/frontend"
  ami_id            = "ami-005fc0f236362e99f"
  key_name          = "Obelion_task"
  instance_type     = "t2.micro"
  security_group_id = module.frontend_sg.id
  subnet_id         = element(module.vpc.public_subnet_ids, 1)
  username          = "ubuntu"
}

module "rds_sg" {
  source = "./modules/security_group"
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"] # Use proper CIDR blocks, not subnet IDs
    }
  ]
}

module "rds" {
  source            = "./modules/rds"
  vpc_id            = module.vpc.vpc_id
  db_name           = "mydb"
  db_username       = "admin"
  db_password       = "password123"
  security_group_id = module.rds_sg.id
  subnet_ids        = module.vpc.public_subnet_ids
  vpc_cidr          = module.vpc.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  vpc_cidr_block    = module.vpc.vpc_cidr_block
}

module "cloudwatch_backend" {
  source       = "./modules/cloudwatch"
  instance_ids = [module.backend.instance_id]
}

module "cloudwatch_frontend" {
  source       = "./modules/cloudwatch"
  instance_ids = [module.frontend.instance_id]
}
