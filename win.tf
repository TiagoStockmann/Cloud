resource "aws_instance" "Windows" {
  ami                         = "ami-03cd80cfebcbb4481"    # AMI Windows Server
  instance_type               = "t2.medium"                 # Tipo de máquina
  subnet_id                   = aws_subnet.Subrede-Pub1.id # Alterar para a subnet pública 1
  key_name                    = "terrakeywin"              # Alterar para sua chave
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Grupo-Sec-Windows.id]
  user_data                   = base64encode(data.template_file.user_data.rendered)

  tags = {
    Name = "Windows-Terraform-01"
  }
}

resource "aws_security_group" "Grupo-Sec-Windows" {
  name        = "Grupo-Sec-Windows"
  description = "Liberar entrada RDP, HTTP e PING"
  vpc_id      = aws_vpc.ANEIS-vpc.id # Alterar para o ID da sua VPC

  # Liberar porta RDP de Entrada
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Liberar porta HTTP de Entrada
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Liberar Ping de Entrada
  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Liberar saída do pacote
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("./scripts/ScriptWin.sh")
}

output "instance_public_ip" {
  description = "IP Público da Instância EC2"
  value       = aws_instance.Windows.public_ip
}