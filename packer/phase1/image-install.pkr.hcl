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

variable "use_kvm" {
  type = bool
  default = false
}

variable "iso_checksum" {
  type = string
}

source "qemu" "ubuntu" {
  accelerator      = var.use_kvm ? "kvm" : "none"
  format           = "qcow2"
  disk_interface   = "virtio"
  disk_size        = "8192M"
  memory           = 2048
  cpus             = 2
  headless         = true
  qemuargs = [
    ["-smbios", "type=1,serial=ds=nocloud;s=/cdrom/"]
  ]
  communicator     = "none"

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
  "linux /casper/vmlinuz autoinstall ---<enter><wait5>",
  "initrd /casper/initrd<enter><wait5>",
  "boot<enter>"
]

  shutdown_command = "shutdown -P now"
}

build {
  name = "ubuntu-kvm-image"

  sources = [
    "source.qemu.ubuntu"
  ]

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

