variable "project_name" {
  description = "Prefijo para nombrar recursos"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Subredes publicas para el ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group para el ALB"
  type        = string
}

variable "target_instance_ids" {
  description = "IDs de las instancias registradas en el target group"
  type        = list(string)
}

variable "target_group_port" {
  description = "Puerto destino para el target group"
  type        = number
  default     = 80
}
