# Snapshots y recuperación

1. Crear snapshots desde la interfaz de TrueNAS en los datasets correspondientes.
2. Crear o modificar un archivo de prueba en un recurso compartido.
3. Confirmar que el snapshot conserva la versión anterior.
4. Recuperar una copia del archivo en una ruta de prueba, sin sobrescribir originales.
5. Verificar contenido, permisos y acceso SMB/NFS.

## Restaurar respaldo tar de referencia

```bash
cd /mnt/pve/HDD-Backups/TrueNAS-2Backup
sha256sum -c truenas-backup-FECHA.tgz.sha256
tar -tzf truenas-backup-FECHA.tgz | head
mkdir -p /tmp/truenas-restore-test
tar -xzf truenas-backup-FECHA.tgz -C /tmp/truenas-restore-test --no-same-owner --no-same-permissions
```

**Precaución:** extraer solamente archivos confiables, inspeccionar rutas del archivo antes de restaurar y nunca hacerlo directamente sobre datasets de producción sin plan de recuperación.
