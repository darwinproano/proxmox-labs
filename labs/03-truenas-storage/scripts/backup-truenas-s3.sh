#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
CONFIG_FILE="${CONFIG_FILE:-/etc/truenas-backup.env}"
[[ -r "$CONFIG_FILE" ]] || { echo "Falta configuración: $CONFIG_FILE" >&2; exit 1; }
# shellcheck disable=SC1090
source "$CONFIG_FILE"
: "${BACKUP_DIR:?}" "${S3_BUCKET:?}" "${S3_PREFIX:?}" "${AWS_PROFILE:?}"
[[ "$S3_BUCKET" != REEMPLAZAR_BUCKET ]] || { echo 'Configurar bucket real' >&2; exit 1; }
command -v aws >/dev/null || { echo 'AWS CLI no instalado' >&2; exit 1; }
latest="$(find "$BACKUP_DIR" -maxdepth 1 -type f -name 'truenas-backup-*.tgz' -printf '%T@ %p
' | sort -nr | head -n 1 | cut -d' ' -f2-)"
[[ -n "$latest" && -f "$latest.sha256" ]] || { echo 'Falta respaldo o checksum' >&2; exit 1; }
(cd "$BACKUP_DIR" && sha256sum -c "$(basename "$latest").sha256")
key="${S3_PREFIX%/}/$(basename "$latest")"
aws --profile "$AWS_PROFILE" s3 cp --only-show-errors -- "$latest" "s3://$S3_BUCKET/$key"
aws --profile "$AWS_PROFILE" s3 cp --only-show-errors -- "$latest.sha256" "s3://$S3_BUCKET/$key.sha256"
echo "Respaldo y checksum enviados a s3://$S3_BUCKET/$key"
# No implica prueba de restauración desde S3: realizar descarga y verificación separadamente.
