###cloud vars
variable "token" {
  type    	= string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-to>
}

variable "cloud_id" {
  type    	= string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type    	= string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type    	= string
  default 	= "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type    	= list(string)
  default 	= ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type    	= string
  default 	= "develop"
  description = "VPC network&subnet name"
}

variable "vm_resources" {
  type     = map(sting)
  default  = {vm_web_cores = "2", vm_web_memory = "1", vm_web_core_fraction = "20"}
}

variable "vm_platform" {
  type = string
  default = "standard-v1"
}

variable "vm_count" {
  type = string
  default = "2"
}

variable "vm_boot_disk" {
  type = map(string)
  default = {vm_boot_disk_type = "network-hdd", vm_boot_disk_size = "5"}
}


