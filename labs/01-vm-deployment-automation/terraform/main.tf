# ============================================================
# Ubuntu 24.04 Cloud Image
# Terraform administra la imagen base utilizada por la VM.
# ============================================================

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "lab-pve-01"

  url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name = "ubuntu-24.04-server-cloudimg-amd64.qcow2"

}

# ============================================================
# VM 102 - Ubuntu Cloud mediante Terraform
# ============================================================

resource "proxmox_virtual_environment_vm" "ubuntu_iac" {

  name      = "vm-ubuntu-iac01"
  node_name = "lab-pve-01"
  vm_id     = 102

  description = "Ubuntu 24.04 Cloud VM desplegada mediante Terraform"

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }


  # Disco principal de la VM
  disk {
    datastore_id = "dstore1-vms"
    interface    = "scsi0"
    size         = 32

    import_from = proxmox_download_file.ubuntu_cloud_image.id
  }

  # Interfaz de red
  network_device {
    bridge   = "vmbr1"
    model    = "virtio"
    firewall = true
  }

  # Configuración Cloud-Init
  initialization {
    ip_config {
      ipv4 {
        address = "10.20.0.12/24"
        gateway = "10.20.0.1"
      }
    }

    user_account {
      username = "ubuntu"

      keys = [
        trimspace(file(pathexpand(var.ssh_public_key_path)))
      ]
    }


  }

}
