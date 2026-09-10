provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token

 # Lab environments commonly use self-signed certificates.
 # Set to false when using a trusted TLS certificate.

  insecure = true
}