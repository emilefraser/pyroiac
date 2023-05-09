packer {
  required_version = ">= 1.7.0, < 2.0.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0, < 2.0.0"
    }
  }
}

variable "boot_wait" {
  type    = string
  default = "10s"
}

variable "headless" {
  type    = string
  default = "true"
}


variable "ssh_agent_auth" {
  type    = string
  default = "false"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_disable_agent_forwarding" {
  type    = string
  default = "false"
}

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "Pyromaniac SSH"
}

variable "ssh_handshake_attempts" {
  type    = string
  default = "100"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "15s"
}

variable "ssh_password" {
  type    = string
  default = "packer"
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_pty" {
  type    = string
  default = "false"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "user_data_location" {
  type    = string
  default = "./cloud-data/user-data"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}




# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "qemu" {
  boot_wait                    = var.boot_wait
  disk_discard                 = "unmap"
  disk_image                   = true
  disk_interface               = "virtio-scsi"
  disk_size                    = "5120M"
  headless                     = var.headless
  http_directory               = "cloud-data"
  iso_checksum                 = "sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931" #"file:http://releases.ubuntu.com/22.04/SHA256SUMS"
  iso_url                      = "http://releases.ubuntu.com/22.04/ubuntu-22.04.2-live-server-amd64.iso"
  qemuargs                     = [["-smbios", "type=1,serial=ds=nocloud-net;instance-id=packer;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"]]
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  ssh_agent_auth               = var.ssh_agent_auth
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_password                 = "packerpassword"
  ssh_port                     = var.ssh_port
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = "packer"
  use_default_display          = true
}

locals {
  output_directory = "build/${legacy_isotime("2006-01-02-15-04-05")}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.qemu.qemu"]

  provisioner "shell" {
    binary            = false
    execute_command   = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    inline = [
      "apt-get update",
      "apt-get --yes dist-upgrade",
      "apt-get clean"
    ]
    inline_shebang      = "/bin/sh -e"
    only                = ["qemu"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = [
    	"/usr/bin/apt-get clean", 
    	"rm -r /etc/apparmor.d/cache/* /etc/apparmor.d/cache/.features /etc/netplan/50-cloud-init.yaml /etc/ssh/ssh_host* /etc/sudoers.d/90-cloud-init-users", 
    	"/usr/bin/truncate --size 0 /etc/machine-id", 
    	"/usr/bin/gawk -i inplace '/PasswordAuthentication/ { gsub(/yes/, \"no\") }; { print }' /etc/ssh/sshd_config", 
    	"rm -r /root/.ssh", 
    	"rm /snap/README", 
    	"find /usr/share/netplan -name __pycache__ -exec rm -r {} +", 
    	"rm /var/cache/pollinate/seeded /var/cache/snapd/* /var/cache/motd-news", 
    	"rm -r /var/lib/cloud /var/lib/dbus/machine-id /var/lib/private /var/lib/systemd/timers /var/lib/systemd/timesync /var/lib/systemd/random-seed", 
    	"rm /var/lib/ubuntu-release-upgrader/release-upgrade-available", 
    	"rm /var/lib/update-notifier/fsck-at-reboot /var/lib/update-notifier/hwe-eol", 
    	"find /var/log -type f -exec rm {} +", 
    	"rm -r /tmp/* /tmp/.*-unix /var/tmp/*", 
    	"for i in group gshadow passwd shadow subuid subgid; do mv /etc/$i- /etc/$i; done", 
    	"rm -r /home/packer", "/bin/sync", 
    	"/sbin/fstrim -v /"
    	]
    remote_folder   = "/tmp"
  }

}
