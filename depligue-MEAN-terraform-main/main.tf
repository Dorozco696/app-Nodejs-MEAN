variable "project_name" {
  description = "Prefijo para nombrar recursos"
  type        = string
  default     = "mean"
}

variable "aws_region" {
  description = "Regi�n de AWS"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subredes p�blicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs de las subredes privadas"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "azs" {
  description = "Zonas de disponibilidad"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "db_ami_id" {
  description = "AMI de MongoDB"
  type        = string
  default     = "ami-04b2d5dc1afcd5aa9"
}

variable "web_ami_id" {
  description = "AMI de Node.js + Nginx"
  type        = string
  default     = "ami-0e0b20afc2bc55c38"
}

variable "db_instance_type" {
  description = "Tipo de instancia para MongoDB"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_type" {
  description = "Tipo de instancia para la capa web"
  type        = string
  default     = "t3.micro"
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "database" {
  source               = "./modules/database"
  project_name         = var.project_name
  ami_id               = var.db_ami_id
  instance_type        = var.db_instance_type
  subnet_id            = module.network.private_subnet_ids[0]
  security_group_id    = module.security.db_sg_id
  iam_instance_profile = module.security.ssm_instance_profile_name
}

module "web" {
  source               = "./modules/web"
  project_name         = var.project_name
  ami_id               = var.web_ami_id
  instance_type        = var.web_instance_type
  subnet_ids           = module.network.public_subnet_ids
  security_group_id    = module.security.web_sg_id
  iam_instance_profile = module.security.ssm_instance_profile_name
  db_private_ip        = module.database.db_private_ip
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  project_name        = var.project_name
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  security_group_id   = module.security.alb_sg_id
  target_instance_ids = module.web.web_instance_ids
  target_group_port   = 80
}

output "nat_ip" {
  value = module.network.nat_public_ip
}

output "subnets_publicas" {
  value = module.network.public_subnet_ids
}

output "subnets_privadas" {
  value = module.network.private_subnet_ids
}

output "db_private_ip" {
  value = module.database.db_private_ip
}

output "web_public_ips" {
  value = module.web.web_public_ips
}

output "alb_dns_name" {
  value = module.loadbalancer.alb_dns_name
}
