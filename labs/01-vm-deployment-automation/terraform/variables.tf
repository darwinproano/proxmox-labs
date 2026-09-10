variable "proxmox_endpoint" {
  description = "URL de la API de Proxmox VE"
  type        = string
}

variable "proxmox_api_token" {
  description = "API Token utilizado por Terraform para autenticarse en Proxmox"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Ruta local de la clave publica SSH utilizada para las VMs del laboratorio"
  type        = string
  default     = "~/.ssh/id_ed25519_proxmox_lab.pub"
}

