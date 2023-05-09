packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

variable "docker_image" {
  type = string
  default = "ubuntu:bionic"
}

variable "docker_image_base" {
  type = string
  default = "ubuntu:xenial"
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntubase" {
  image  = var.docker_image_base
  commit = true
}


build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntubase",
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "learn-packer"
      tags       = ["ubuntu-xenial", "packer-rocks"]
      only       = ["docker.ubuntubase"]
    }

    post-processor "docker-tag" {
      repository = "learn-packer"
      tags       = ["ubuntu-bionic", "packer-rocks"]
      only       = ["docker.ubuntu"]
    }
  }
}
