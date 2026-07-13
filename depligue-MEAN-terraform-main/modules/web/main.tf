resource "aws_instance" "web" {
  count                   = length(var.subnet_ids)
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_ids[count.index]
  vpc_security_group_ids  = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile    = var.iam_instance_profile

  user_data = <<EOF
#!/bin/bash
cat > /var/www/nodeapp/backend/.env <<EOT
MONGO_URI=mongodb://${var.db_private_ip}:27017/tarea2db
EOT

systemctl restart nodeapp
EOF

  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}
