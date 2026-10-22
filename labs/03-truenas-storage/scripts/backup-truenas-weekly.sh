#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
CONFIG_FILE="${CONFIG_FILE:-/etc/truenas-backup.env}"
[[ -r "$CONFIG_FILE" ]] || { echo "No se encuentra configuración: $CONFIG_FILE" >&2; exit 1; }
# Archivo local controlado por administrador, nunca obtenido de fuentes no confiables.
# shellcheck disable=SC1090
source "$CONFIG_FILE"
: "${TRUENAS_HOST:?}" "${TRUENAS_USER:?}" "${TRUENAS_SMB_PATH:?}" "${TRUENAS_NFS_PATH:?}" "${BACKUP_DIR:?}" "${SSH_KEY:?}"
MIN_AGE_HOURS="${MIN_AGE_HOURS:-144}"
[[ "$MIN_AGE_HOURS" =~ ^[0-9]+$ ]] || { echo 'MIN_AGE_HOURS debe ser entero' >&2; exit 1; }
mkdir -p -- "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"
exec 9>"$BACKUP_DIR/.backup.lock"
flock -n 9 || { echo 'Ya hay un respaldo en ejecución' >&2; exit 1; }
# No repetir si hay un respaldo reciente; comprobación basada en edad real del archivo.
recent="$(find "$BACKUP_DIR" -maxdepth 1 -type f -name 'truenas-backup-*.tgz' -mmin "-$((MIN_AGE_HOURS*60))" -print -quit)"
if [[ -n "$recent" ]]; then echo "Ya existe un respaldo reciente: $recent"; exit 0; fi
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
out="$BACKUP_DIR/truenas-backup-$stamp.tgz"
tmp="$(mktemp "$BACKUP_DIR/.truenas-backup.XXXXXXXX.tgz")"
trap 'rm -f -- "$tmp"' EXIT
# Paths se transmiten como argumentos a bash remoto con printf %q (se asume bash disponible).
remote_cmd="tar -C / -czf - -- $(printf '%q ' "${TRUENAS_SMB_PATH#/}" "${TRUENAS_NFS_PATH#/}")"
ssh -i "$SSH_KEY" -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=15 -- "${TRUENAS_USER}@${TRUENAS_HOST}" "$remote_cmd" > "$tmp"
tar -tzf "$tmp" >/dev/null
mv -- "$tmp" "$out"
trap - EXIT
(cd "$BACKUP_DIR" && sha256sum "$(basename "$out")" > "$(basename "$out").sha256")
(cd "$BACKUP_DIR" && sha256sum -c "$(basename "$out").sha256")
echo "Respaldo creado y validado: $out"
