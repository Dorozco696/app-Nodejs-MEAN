variable "project_name" {
  description = "Prefijo para nombrar recursos"
  type        = string
}

variable "ami_id" {
  description = "AMI para MongoDB"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia para MongoDB"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subred privada donde se desplegará MongoDB"
  type        = string
}

variable "security_group_id" {
  description = "Security group para MongoDB"
  type        = string
}

variable "iam_instance_profile" {
  description = "Perfil de instancia para permisos SSM"
  type        = string
}
