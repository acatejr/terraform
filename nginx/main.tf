terraform {
    required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.13"
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_droplet" "web" {
    image  = "ubuntu-20-10-x64"
    name   = "web-1"
    region = "nyc1"
    size   = "s-1vcpu-1gb"
    connection {
        host = digitalocean_droplet.web.ipv4_address
        user = "root"
        type = "ssh"
        # private_key = file(var.pvt_key)
        timeout = "2m"
    }
    provisioner "remote-exec" {
        inline = [
            "export PATH=$PATH:/usr/bin",
            # install nginx
            "sudo apt-get update",
            "sudo apt-get -y install nginx"
        ]
  }
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}