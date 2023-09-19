data "aws_region" "current" {}

resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}-ec2"
  description = "Allow Ec2 Access Bumbii"
  vpc_id      = var.vpc_id

  ingress {
    description = "ec2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks_ssh
  }

  ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks_jenkins
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.prefix}_web_sg"
  }
}


resource "aws_eip" "web_eip" {
  count    = var.settings.web_app.count
  instance = aws_instance.web_instance[count.index].id
  domain   = "vpc"
  tags     = {
    Name = "${var.prefix}_web_eip"
  }
}

#data "aws_ami" "ubuntu" {
#  most_recent = true
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#  owners = ["099720109477"] # Canonical
#}

resource "aws_instance" "web_instance" {
  count         = var.settings.web_app.count
  ami           = var.aws_ami
  instance_type = var.settings.web_app.instance_type
  key_name      = var.key_pem

  subnet_id              = var.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOL
  #!/bin/bash -xe
  sudo yum update
  sudo yum -y install docker
  sudo service docker start
  sudo systemctl enable docker
  sudo usermod -a -G docker ec2-user
  sudo chmod 666 /var/run/docker.sock
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose version
  sudo yum update
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum upgrade
  sudo dnf install java-11-amazon-corretto -y
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  sudo systemctl status jenkins
  sudo usermod -a -G jenkins ec2-user
  sudo yum update
  sudo yum install git -y
  git version
  cd /home/ec2-user/
  sudo mkdir projects
  sudo chmod 777 projects
  cd projects/
  sudo git clone https://hoangtuananh97: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@github.com/hoangtuananh97/gitops-demo.git
  cd gitops-demo/
  sudo git status
  sudo git config --global --add safe.directory /home/ec2-user/projects/gitops-demo
  sudo cp config/settings/env.example config/settings/.env
  sudo mkdir logs
  sudo chmod 777 logs
  sudo docker-compose -f docker-compose.dev.yml up -d
  EOL


  tags = var.tags
}

#pipeline {
#    agent any
#    options {
#        skipDefaultCheckout true
#    }
#
#    stages {
#        stage('Clone Repository') {
#            steps {
#                git branch: "${env.BRANCH_NAME}", url: "main"
#            }
#        }
#
#        stage('Build') {
#            steps {
#                sh "git status"
#                sh "git config --global --add safe.directory ${"WORKSPACE"}"
#                sh "cp config/settings/env.example config/settings/.env"
#                sh "mkdir logs"
#            }
#        }
#
#        stage('Deploy') {
#            steps {
#                sh "docker-compose -f docker-compose.dev.yml up -d"
#            }
#        }
#    }
#
#}
