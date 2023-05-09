
variable "config_file" {
  type    = string
  default = "almalinux8-kickstart.cfg"
}

variable "cpu" {
  type    = string
  default = "2"
}

variable "destination_server" {
  type    = string
  default = "download.goffinet.org"
}

variable "disk_size" {
  type    = string
  default = "40000"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:de92004fcc5bb5b9af586c9b5ab0e0c7c5a5eedce4d2be85156c5dd31a4fa81b"
}

variable "iso_url" {
  type    = string
  default = "https://repo.almalinux.org/almalinux/8/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso"
}

variable "name" {
  type    = string
  default = "almalinux"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "ssh_password" {
  type    = string
  default = "testtest"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "version" {
  type    = string
  default = "8"
}

source "qemu" "almalinux8" {
  accelerator      = "kvm"
  boot_command     = ["<up><wait><tab><wait> net.ifnames=0 biosdevname=0 text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/${var.config_file}<enter><wait>"]
  boot_wait        = "40s"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_interface   = "virtio"
  disk_size        = var.disk_size
  format           = "qcow2"
  headless         = var.headless
  http_directory   = "."
  iso_checksum     = var.iso_checksum
  iso_url         = var.iso_url
  net_device       = "virtio-net"
  output_directory = "artifacts/qemu/${var.name}${var.version}"
  qemu_binary      = "/usr/bin/qemu-system-x86_64"
  qemuargs         = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command = "sudo /usr/sbin/shutdown -h now"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_wait_timeout = "30m"
}

build {
  sources = ["source.qemu.almalinux8"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = ["yum -y install epel-release", "yum repolist", "yum -y install ansible"]
  }

  provisioner "ansible-local" {
    playbook_dir  = "ansible"
    playbook_file = "ansible/playbook.yml"
  }

  post-processor "shell-local" {
    environment_vars = ["IMAGE_NAME=${var.name}", "IMAGE_VERSION=${var.version}", "DESTINATION_SERVER=${var.destination_server}"]
    script           = "scripts/push-image.sh"
  }
}
