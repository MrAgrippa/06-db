resource "yandex_compute_instance" "web" {
  count = var.vm_count
  name = "develop-web-${count.index + 1}"
  platform_id = var.vm_platform

  resources {
	cores     	= var.vm_resources.vm_web_cores
	memory    	= var.vm_resources.vm_web_memory 
	core_fraction = var.vm_resources.vm_web_core_fraction 
  }

  boot_disk {
	initialize_params {
  	image_id = "fd8g64rcu9fq5kpfqls0"
        type = var.vm_boot_disk.vm_boot_disk_type
        size = var.vm_boot_disk.vm_boot_disk_size
	}
  }

  network_interface {
	subnet_id = yandex_vpc_subnet.develop.id
	nat   	= true
  }

  metadata = {
	ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
