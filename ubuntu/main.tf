# Configuração do Terraform
terraform {
  required_version = ">=1.6.0" # Versão do Terraform

  # Provedores Utilizados
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0" # Versão do AWS no Terraform
    }
  }
}

provider "aws" { 
  region                   = "us-east-1"
  shared_config_files      = ["C:/Users/51353562824/.aws/config"]
  shared_credentials_files = ["C:/Users/51353562824/.aws/credentials"]

  default_tags {
    tags = {
      owner      = "Tiago"
      managed-by = "Terraform"
    }
  }
}