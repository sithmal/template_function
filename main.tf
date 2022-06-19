terraform {
  required_version = ">= 0.13.1"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.4.0"
    }
  }
}

provider "local" {}
provider "tls" {}

# RSA key of size 4096 bits
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# provisioner "file" {
#   source = 
#   destination = "resolv.conf"
# }


resource "local_file" "postfix_config" {
  filename = "config.yaml"
  content  = templatefile("config.tftpl",
    {
      prv_key = tls_private_key.ssh.private_key_openssh
      pub_key = tls_private_key.ssh.public_key_openssh
  })
}