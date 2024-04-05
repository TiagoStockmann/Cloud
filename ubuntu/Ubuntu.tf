resource "aws_instance" "Linux" {
  ami                         = "ami-080e1f13689e07408"    #AMI Ubuntu
  instance_type               = "t2.micro"                 # Tipo de maquina
  subnet_id                   = "subnet-00429e4c09a6090b2" #alterar subnet Publica 1
  key_name                    = "terraKey"                 #alterar da sua chave
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Grupo-Sec-Linux-Ubuntu.id]
  user_data                   = base64encode(data.template_file.user_data.rendered)

  tags = {
    Name = "Linux-Terraform-01"
  }
}

###### GRUPO DE SERGURANÇA ######
resource "aws_security_group" "Grupo-Sec-Linux-Ubuntu" {
  name        = "Grupo-Sec-Linux-Ubuntu"
  description = "Liberar entrada SSH, HTTP e PING"
  vpc_id      = "vpc-0027379a3d7cb9b9b" # Trocar para o ID da sua VPC

  #Liberar porta SSH de Entrada
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Liberar porta HTTP de Entrada
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Liberar Ping de Entrada
  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Liberar saida do pacote
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########### EC2 ###########
data "template_file" "user_data" {
  template = file("./scripts/site_ubuntu.sh")
}

output "instance_public_ip" {
  description = "IP Publico da Instancia EC2"
  value       = aws_instance.Linux.public_ip
}
