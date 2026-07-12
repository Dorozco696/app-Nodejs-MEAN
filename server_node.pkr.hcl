//AWS Packer Builder
packer {
    required_plugins {
        amazon = {
            version = ">= 1.0.0"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu_node_nginx2" {
    region = "us-east-2"
    source_ami = "ami-0ea1cddefe0c4aed5"
    instance_type = "t3.micro"
    ssh_username = "ubuntu"
    ami_name = "packer-node-nginx2-aws"
    ami_description = "Ubuntu 24.04 con Node.js y Nginx2 configurado"
    associate_public_ip_address = true
    ssh_timeout = "10m"
    tags = {
        Name = "packer-node-nginx2-aws"
    }
}

build {
    sources = ["source.amazon-ebs.ubuntu_node_nginx2"]
    
    provisioner "file" {
        source = "backend"
        destination = "/tmp/backend"
    }
    provisioner "file" {
        source = "frontend"
        destination = "/tmp/frontend"
    }
    
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install -y nginx curl",
            "curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -",
            "sudo apt-get install -y nodejs",
            "sudo mkdir -p /var/www/nodeapp/backend/",
            "sudo cp -r /tmp/backend/* /var/www/nodeapp/backend/",
            "sudo mkdir -p /var/www/nodeapp/frontend/",
            "sudo cp -r /tmp/frontend/* /var/www/nodeapp/frontend/",
            "sudo chown -R ubuntu:ubuntu /var/www/nodeapp",
            "cd /var/www/nodeapp/backend",
            "sudo npm install --production",
            "sudo cp /var/www/nodeapp/backend/nodeapp /etc/nginx/sites-available/nodeapp",
            "sudo ln -sf /etc/nginx/sites-available/nodeapp /etc/nginx/sites-enabled/nodeapp",
            "sudo rm -f /etc/nginx/sites-enabled/default",
            "sudo nginx -t",
            "sudo systemctl enable nginx",
            "sudo systemctl restart nginx",
            "sudo npm install -g pm2",
            "pm2 start /var/www/nodeapp/backend/server.js",
            "sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu",
            "pm2 save",
        ]
    }
}