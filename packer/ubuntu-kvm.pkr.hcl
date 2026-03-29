packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

source "qemu" "ubuntu" {
  accelerator      = "none"
  format           = "qcow2"
  disk_interface   = "virtio"
  disk_size        = "8192"
  memory           = 2048
  cpus             = 2
  headless         = true
  qemuargs = [
    ["-display","none"],
    ["-serial", "stdio"]
  ]
  communicator     = "ssh"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "60m"

  pause_before_connecting = "5m"
# ssh_private_key_file = "http/packer"
  ssh_handshake_attempts = 20
  vm_name          = "ubuntu-baked-demo"
  output_directory = "output/ubuntu-kvm"

  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum

  cd_files = [
    "http/user-data",
    "http/meta-data"
  ]
  cd_label = "cidata"

  http_directory   = "http"

boot_wait = "30s"
boot_command = [
  "c<wait>",
  # Adding systemd.mask=ssh to the kernel line -- an automated install does not need an interactive SSH session
  "linux /casper/vmlinuz autoinstall ds=nocloud;s=/cdrom/ systemd.mask=ssh ---<enter><wait>",
  "initrd /casper/initrd<enter><wait>",
  "boot<enter>"
]

  shutdown_command = "shutdown -P now"
}

build {
  name = "ubuntu-kvm-image"

  sources = [
    "source.qemu.ubuntu"
  ]

  provisioner "shell" {
    script = "scripts/baseline.sh"
  }

  provisioner "shell-local" {
    inline = [
      "mkdir -p output",
      "date -u +%Y-%m-%dT%H:%M:%SZ > output/build-timestamp.txt"
    ]
  }

  post-processor "manifest" {
    output = "ubuntu-kvm.manifest.json"
  }
}
