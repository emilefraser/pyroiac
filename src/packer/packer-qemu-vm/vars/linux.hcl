headless         = true
qemu_accelerator = "kvm"

iso_url           = "http://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img"
iso_checksum      = "http://cloud-images.ubuntu.com/releases/jammy/release/SHA256SUMS"
iso_checksum_type = "file"

cpus      = "2"
memory    = "2048"
disk_size = "19200"

boot_wait           = "1m"
