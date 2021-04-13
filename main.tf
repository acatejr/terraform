terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.7.0"
    }
  }
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_ssh_key" "web" {
    name = "Web App SSH Key"
    public_key = file("${path.module}/files/id_rsa.pub")
}

resource "digitalocean_droplet" "web" {
    image  = "ubuntu-20-10-x64"
    name   = "web"
    region = "nyc1"
    size   = "s-1vcpu-1gb"
    monitoring = true
    private_networking = true
    ssh_keys = [
        digitalocean_ssh_key.web.id
    ]
    user_data = file("${path.module}/files/user-data.sh")
}
