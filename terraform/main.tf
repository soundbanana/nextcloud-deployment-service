terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id                 = var.CLOUD_ID
  folder_id                = var.FOLDER_ID
  service_account_key_file = var.SERVICE_ACCOUNT_KEY_FILE_PATH
  zone                     = var.AVAILABILITY_ZONE
}

# Variables
variable "CLOUD_ID" {
  type        = string
  description = "Yandex Cloud ID."
}

variable "FOLDER_ID" {
  type        = string
  description = "Yandex Cloud Folder ID."
}

variable "SERVICE_ACCOUNT_KEY_FILE_PATH" {
  type        = string
  description = "Path to the key for service account with admin role."
}

variable "AVAILABILITY_ZONE" {
  type        = string
  description = "Availability zone code for Yandex Cloud"
  default     = "ru-central1-d"
}

