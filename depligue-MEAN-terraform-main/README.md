# MEAN multicapa en AWS con Terraform

Despliegue de un stack MEAN (MongoDB, Express, Angular, Node.js) sobre AWS usando
Terraform con arquitectura modularizada, balanceador de carga y red segmentada en
subredes públicas y privadas.

## Arquitectura

- **VPC** con subredes públicas (ALB + capa web) y privadas (MongoDB)
- **Internet Gateway** para el tráfico público
- **NAT Gateway** para la salida a internet de instancias en subredes privadas
- **ALB** como punto único de entrada HTTP
- Capa web **Nginx + Node.js** escalable
- **MongoDB** aislado en subred privada

## Requisitos

- Terraform >= 1.5
- Cuenta de AWS con un usuario IAM y access keys configuradas
- AWS CLI (opcional pero recomendado)

## Estructura

```text
mean-terraform/
├── main.tf                  # Módulo raíz: orquesta los módulos
├── modules/
│   └── network/             # VPC, subredes, IGW, NAT, rutas
│       ├── variables.tf
│       ├── main.tf
│       └── outputs.tf
└── README.md
```

## Configuración de credenciales

```bash
aws configure

# o bien:

export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="us-east-1"
```

## Uso

```bash
# 1. Inicializar (descarga el provider de AWS)
terraform init

# 2. Revisar el formato y la sintaxis
terraform fmt
terraform validate

# 3. Ver que se va a crear SIN aplicar nada
terraform plan

# 4. Crear la infraestructura (pide confirmación: escribe "yes")
terraform apply

# 5. Ver los outputs (IPs, DNS, etc.)
terraform output

# 6. IMPORTANTE: destruir todo al terminar para no generar costos
terraform destroy
```

## Notas de costos

- VPC, subredes, Internet Gateway y tablas de rutas: **gratis**
- **NAT Gateway: cobra por hora** (no está en capa gratuita)
- Ejecutar `terraform destroy` al terminar cada sesión de trabajo

## Estado del proyecto

- [x] Módulo network (VPC, subredes, IGW, NAT, rutas)
- [ ] Módulo security (security groups)
- [ ] Módulo database (MongoDB)
- [ ] Módulo web (Nginx + Node.js)
- [ ] Módulo loadbalancer (ALB)
- [ ] Módulo raíz + output.tf
- [ ] Backend remoto S3 + DynamoDB

## Equipo

- Persona A: Red (módulo network)
- Persona B: Seguridad + Base de datos
- Persona C: Web + Balanceador
- Persona D: Integración, outputs y documentación
