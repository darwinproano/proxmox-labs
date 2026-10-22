# Validación de respaldo

El script local genera `truenas-backup-YYYYMMDDTHHMMSSZ.tgz` y un archivo `.sha256`. Verifica la legibilidad de la estructura tar y la suma SHA-256.

```bash
cd /mnt/pve/HDD-Backups/TrueNAS-2Backup
sha256sum -c truenas-backup-FECHA.tgz.sha256
tar -tzf truenas-backup-FECHA.tgz | head
systemctl status backup-truenas.timer
journalctl -u backup-truenas.service -n 50 --no-pager
```

Validar restauración en directorio temporal, permisos y archivos de muestra. Comprobar que el backup contenga datos esperados y no sea solo un tar vacío.

S3: realizar una descarga de prueba a un directorio aislado y comparar SHA-256. El script de carga por sí solo no verifica recuperación.
