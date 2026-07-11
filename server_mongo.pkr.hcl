//AWS Packer Builder
packer {
    required_plugins {
        amazon = {
            version = ">= 1.0.0"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu_mongodb" {
    region = "us-east-2"
    source_ami = "ami-0ea1cddefe0c4aed5"
    instance_type = "t3.micro"
    ssh_username = "ubuntu"
    ami_name = "packer-mongodb-aws"
    ami_description = "Ubuntu 24.04 con MongoDB configurado"
    //associate_public_ip_address = true
    ssh_timeout = "10m"
    tags = {
        Name = "packer-mongodb-aws"
    }
}

build {
    sources = ["source.amazon-ebs.ubuntu_mongodb"]
    
    provisioner "shell" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install gnupg curl -y",
            "curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor",
            "echo \"deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list",
            "sudo apt update",
            "sudo apt install -y mongodb-org",
            "sudo systemctl start mongod.service",
            "sudo systemctl enable mongod.service",
            "sudo sed -i 's/^  bindIp: .*/  bindIp: 0.0.0.0/' /etc/mongod.conf",
            "sudo systemctl restart mongod",
            "sudo systemctl status mongod --no-pager",
            "sudo ss -tlnp | grep 27017 || true"
        ]
    }
}