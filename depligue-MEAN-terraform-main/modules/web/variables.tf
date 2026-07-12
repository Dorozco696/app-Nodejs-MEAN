variable "project_name" {
  description = "Prefijo para nombrar recursos"
  type        = string
}

variable "ami_id" {
  description = "AMI para la capa web"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia para la capa web"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "Subredes publicas para la capa web"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group para las instancias web"
  type        = string
}

variable "iam_instance_profile" {
  description = "Perfil de instancia para permisos SSM"
  type        = string
}

variable "db_private_ip" {
  description = "IP privada de MongoDB para configuración"
  type        = string
}
