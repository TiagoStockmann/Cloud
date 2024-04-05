#!/bin/bash
# Atualizar o sistema Debian
sudo su -
apt update -y

# Instalar Apache2
apt install apache2 -y

# Instalar o Git
apt install git -y

#Remover diretório padrão do apache
rm /var/www/html/index.html

# Clonar o repositório do GitHub para /var/www/html
git clone https://github.com/FofuxoSibov/sitebike.git /var/www/html/

# Iniciar Apache2
systemctl enable apache2
systemctl start apache2

# Ajustar permissões
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
