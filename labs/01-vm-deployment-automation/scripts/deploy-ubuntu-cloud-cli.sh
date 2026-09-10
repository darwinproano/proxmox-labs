#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Proxmox VE - Ubuntu 24.04 Cloud Image Deployment
# Reutilizable para laboratorios y entornos Proxmox VE.
# Ajuste las variables de configuración antes de ejecutar.
# No contiene contraseñas ni secretos.
# ============================================================

# ---------- VARIABLES EDITABLES ----------
VMID="101"
VM_NAME="vm-ubuntu-cli01"

CLOUD_IMAGE="/var/lib/vz/template/iso/ubuntu-24.04-server-cloudimg-amd64.img"
STORAGE="dstore1-vms"
BRIDGE="vmbr1"

IP_CIDR="10.20.0.11/24"
GATEWAY="10.20.0.1"

CI_USER="ubuntu"
MEMORY_MIB="2048"
CORES="2"
SOCKETS="1"
CPU_TYPE="host"
DISK_SIZE="32G"

ENABLE_FIREWALL="1"
ENABLE_QEMU_AGENT="1"
START_VM="1"
# ----------------------------------------

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

die() {
  printf '\nERROR: %s\n' "$*" >&2
  exit 1
}

cleanup_on_error() {
  local exit_code=$?
  printf '\nDeployment stopped with exit code %s.\n' "$exit_code" >&2
  printf 'Review the VM with: qm config %s\n' "$VMID" >&2
  exit "$exit_code"
}
trap cleanup_on_error ERR

[[ $EUID -eq 0 ]] || die "Ejecuta este script como root en el nodo Proxmox."

for cmd in qm pvesm qemu-img ip awk grep; do
  command -v "$cmd" >/dev/null 2>&1 || die "No se encontró el comando requerido: $cmd"
done

[[ -f "$CLOUD_IMAGE" ]] || die "No existe la Cloud Image: $CLOUD_IMAGE"

log "Validando Cloud Image"
qemu-img info "$CLOUD_IMAGE" >/dev/null

log "Validando storage: $STORAGE"
pvesm status | awk -v s="$STORAGE" '$1==s && $3=="active"{found=1} END{exit !found}' \
  || die "El storage '$STORAGE' no existe o no está activo."

log "Validando bridge: $BRIDGE"
ip link show "$BRIDGE" >/dev/null 2>&1 \
  || die "No existe el bridge '$BRIDGE'."

if qm status "$VMID" >/dev/null 2>&1; then
  die "El VMID $VMID ya existe. Cambia VMID antes de continuar."
fi

log "Creando VM $VMID ($VM_NAME)"
qm create "$VMID" \
  --name "$VM_NAME" \
  --memory "$MEMORY_MIB" \
  --cores "$CORES" \
  --sockets "$SOCKETS" \
  --cpu "$CPU_TYPE" \
  --ostype l26 \
  --scsihw virtio-scsi-single \
  --net0 "virtio,bridge=${BRIDGE},firewall=${ENABLE_FIREWALL}" \
  --agent "enabled=${ENABLE_QEMU_AGENT}"

log "Importando Cloud Image"
qm importdisk "$VMID" "$CLOUD_IMAGE" "$STORAGE"

IMPORTED_DISK="$(
  qm config "$VMID" |
    awk -F': ' '/^unused[0-9]+:/ {print $2; exit}'
)"

[[ -n "$IMPORTED_DISK" ]] \
  || die "No se pudo detectar el disco importado en qm config."

log "Disco importado detectado: $IMPORTED_DISK"

log "Asociando disco como scsi0"
qm set "$VMID" \
  --scsi0 "${IMPORTED_DISK},iothread=1"

log "Ampliando disco a $DISK_SIZE"
qm resize "$VMID" scsi0 "$DISK_SIZE"

log "Añadiendo Cloud-Init Drive"
qm set "$VMID" \
  --ide0 "${STORAGE}:cloudinit"

log "Configurando usuario y red Cloud-Init"
qm set "$VMID" \
  --ciuser "$CI_USER" \
  --ipconfig0 "ip=${IP_CIDR},gw=${GATEWAY}"

log "Configurando boot desde scsi0"
qm set "$VMID" \
  --boot "order=scsi0"

log "Generando Cloud-Init ISO"
qm cloudinit update "$VMID"

echo
echo "Se solicitará la contraseña inicial de Cloud-Init."
echo "La contraseña NO se guarda en este script."
qm set "$VMID" --cipassword

log "Regenerando Cloud-Init ISO con la contraseña definida"
qm cloudinit update "$VMID"

log "Configuración final"
qm config "$VMID"

if [[ "$START_VM" == "1" ]]; then
  log "Arrancando VM $VMID"
  qm start "$VMID"
else
  log "VM creada pero no iniciada (START_VM=0)"
fi

cat <<EOF

============================================================
DESPLIEGUE COMPLETADO
============================================================
VMID:       $VMID
Nombre:     $VM_NAME
IP:         $IP_CIDR
Gateway:    $GATEWAY
Bridge:     $BRIDGE
Storage:    $STORAGE
Disco:      $DISK_SIZE
Usuario:    $CI_USER

Validaciones recomendadas dentro de Ubuntu:
  hostname
  ip -br addr
  ip route
  ping -c 4 $GATEWAY
  ping -c 4 8.8.8.8
  ping -c 4 google.com
  df -h /

QEMU Guest Agent:
  La VM queda configurada en Proxmox para usar el agente.
  Si la imagen no incluye el paquete:
    sudo apt update
    sudo apt install -y qemu-guest-agent
============================================================
EOF
