resource "yandex_vpc_network" "network" {
  name = var.NETWORK_NAME
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.SUBNET_NAME
  zone           = var.AVAILABILITY_ZONE
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network.id
}

data "yandex_compute_image" "ubuntu_image" {
  family = var.BOOT_IMAGE_FAMILY_NAME
}

resource "yandex_compute_disk" "boot_disk" {
  name     = var.BOOT_DISK_NAME
  type     = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size     = 10
}

resource "yandex_compute_instance" "server" {
  name        = var.SERVER_NAME
  platform_id = "standard-v3"
  hostname    = "server"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 1
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.SSH_PUBLIC_KEY_PATH)}"
  }
}

resource "yandex_dns_zone" "zone" {
  zone   = var.DNS_ZONE
  name   = var.DNS_ZONE_NAME
  public = true
}

resource "yandex_dns_recordset" "recordset" {
  zone_id = yandex_dns_zone.zone.id
  name    = var.DNS_NAME
  type    = "A"
  ttl     = 300
  data    = [yandex_compute_instance.server.network_interface[0].nat_ip_address]
}

# Variables
variable "NETWORK_NAME" {
  type    = string
  default = "vvot39-network"
}

variable "SUBNET_NAME" {
  type    = string
  default = "vvot39-subnet"
}

variable "BOOT_IMAGE_FAMILY_NAME" {
  type    = string
  default = "ubuntu-2404-lts-oslogin"
}

variable "BOOT_DISK_NAME" {
  type    = string
  default = "vvot39-boot-disk"
}

variable "SERVER_NAME" {
  type    = string
  default = "vvot39-server"
}

variable "SSH_PUBLIC_KEY_PATH" {
  type        = string
  description = "Path to public ssh-key for server access"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "SSH_PRIVATE_KEY_PATH" {
  type        = string
  description = "Path to private ssh-key for server access"
  default     = "~/.ssh/id_ed25519"
}

variable "DNS_ZONE" {
  type    = string
  default = "vvot39.itiscl.ru."
}
variable "DNS_ZONE_NAME" {
  type    = string
  default = "ru-itiscl-vvot39"
}

variable "DNS_NAME" {
  type    = string
  default = "project"
}