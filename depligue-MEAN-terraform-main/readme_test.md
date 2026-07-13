# Despliegue Terraform en AWS con MongoDB y Node.js/Nginx

## 1. Requisitos

- Terraform instalado.
- AWS CLI instalado.
- Credenciales configuradas en Windows con `aws configure`.
- Región predeterminada: `us-east-2`.

## 2. Módulos implementados

- `modules/network`: VPC, subredes públicas y privadas, Internet Gateway, NAT Gateway, tablas de ruta.
- `modules/security`: Security Groups, rol IAM y perfil de instancia SSM.
- `modules/database`: Instancia MongoDB en subred privada.
- `modules/web`: Instancias Node.js + Nginx en subred pública.
- `modules/loadbalancer`: ALB público y target group.

## 3. Cómo ejecutar

1. Abrir PowerShell en la carpeta del proyecto.
2. Inicializar Terraform:
   ```powershell
   terraform init
   ```
3. Formatear el código:
   ```powershell
   terraform fmt
   ```
4. Validar configuración:
   ```powershell
   terraform validate
   ```
5. Ver el plan de despliegue:
   ```powershell
   terraform plan
   ```
6. Aplicar la infraestructura:
   ```powershell
   terraform apply
   ```
   Confirma escribiendo `yes`.

## 4. Outputs importantes

Al terminar, ejecuta:
```powershell
terraform output
```

Debes ver:
- `alb_dns_name`
- `db_private_ip`
- `web_public_ips`
- `subnets_publicas`
- `subnets_privadas`


## 5. Conexión SSH con AWS Systems Manager (SSM)

### 5.1 Requisitos previos

- El rol IAM `AmazonSSMManagedInstanceCore` debe estar adjuntado a la instancia.
- La instancia debe estar en una VPC con acceso a internet o a endpoints SSM.
- El agente SSM (`amazon-ssm-agent`) debe estar instalado en la AMI.

### 5.2 Comandos en PowerShell

1. Verificar que las credenciales AWS están activas:
   ```powershell
   aws sts get-caller-identity
   ```
2. Listar instancias administradas por SSM:
   ```powershell
   aws ssm describe-instance-information
   ```
3. Conectarse (sin llave SSH) a la instancia:
   ```powershell
   aws ssm start-session --target <InstanceId>
   ```

### 5.3 Conexión directa con el plugin de SSM

Instala el plugin Session Manager si no lo tienes:
```powershell
Invoke-WebRequest -Uri https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPlugin.zip -OutFile .\SessionManagerPlugin.zip
Expand-Archive .\SessionManagerPlugin.zip .\SessionManagerPlugin
```

Y luego:
```powershell
Start-Process aws ssm start-session --argumentlist '--target', '<InstanceId>'
```

## 6. Detalles de la arquitectura

- `MongoDB` corre en una instancia privada sin IP pública.
- `Node.js + Nginx` corre en subred pública y recibe tráfico desde el ALB.
- `MongoDB` permite conexión por el puerto `27017` únicamente desde las instancias web.
- El ALB expone `HTTP 80` hacia las instancias web.

## 7. Destruir la infraestructura

Cuando termines, elimina todo con:
```powershell
terraform destroy
```

Confirma con `yes`.
