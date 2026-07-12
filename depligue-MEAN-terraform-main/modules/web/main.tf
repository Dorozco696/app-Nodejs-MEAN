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
cat > /etc/profile.d/mongo_host.sh <<EOT
export MONGODB_HOST="${var.db_private_ip}"
EOT
EOF

  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}

output "web_instance_ids" {
  value = aws_instance.web[*].id
}

output "web_private_ips" {
  value = aws_instance.web[*].private_ip
}

output "web_public_ips" {
  value = aws_instance.web[*].public_ip
}
