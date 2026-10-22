# Lab 03 — TrueNAS SCALE sobre Proxmox VE

Laboratorio de almacenamiento con ZFS, SMB, NFS, snapshots y respaldos locales y opcionalmente Amazon S3.

> **Importante:** scripts de referencia reconstruidos a partir de la arquitectura documentada. No son copias verificadas de los scripts ejecutados en el homelab. Revisar rutas, usuarios, permisos y probar antes de habilitar timers.

## Arquitectura de referencia
- Proxmox VE: VM 109 TrueNAS SCALE (4 vCPU, 8 GiB RAM), boot 32 GiB y disco de datos de 2 TB por passthrough.
- TrueNAS: `192.168.18.15`, pool `pool1`, datasets `smb-compartida` y `nfs-seguridad` (verificar nombres y rutas reales).
- SMB para Windows; NFS para red `172.16.20.0/24`.
- Destino local histórico: `/mnt/pve/HDD-Backups/TrueNAS-2Backup/`.

## Uso
1. Revisar `config/backup-truenas.env.example` y crear `/etc/truenas-backup.env` con permisos `600`.
2. Configurar autenticación SSH por clave desde Proxmox a TrueNAS; limitar acceso a datasets requeridos. Nunca almacenar claves en Git.
3. Instalar `scripts/backup-truenas-weekly.sh` en `/usr/local/sbin/backup-truenas-weekly.sh`, `chmod 750`.
4. Opcional S3: instalar AWS CLI, configurar perfil IAM de mínimo privilegio y copiar `scripts/backup-truenas-s3.sh` a `/usr/local/sbin/`.
5. Instalar unidades de `systemd/` en `/etc/systemd/system/`, ejecutar `systemctl daemon-reload`, y habilitar `systemctl enable --now backup-truenas.timer` **solo tras prueba manual**.
6. Ejecutar una prueba de restauración en entorno aislado. Comprobar integridad SHA-256 antes de extraer.

## Notas de seguridad
- No subir backups, credenciales, `.env`, claves privadas, dumps o datos personales.
- `tar` de archivos compartidos **no** sustituye a un respaldo nativo de configuración TrueNAS, de snapshots ZFS o de discos de VM.
- El respaldo por SSH requiere que el usuario remoto tenga permiso de lectura. La captura puede ser inconsistente si los archivos cambian durante el proceso; para producción, respaldar desde snapshots coherentes.
- S3 genera cargos de almacenamiento y transferencia; habilitarlo solo con presupuesto, bucket y credenciales verificados.

Artículo: https://conocimientoit.wordpress.com/2026/10/22/lab-03-implementacion-de-nas-con-truenas-scale-sobre-proxmox-ve-zfs-smb-nfs-snapshots-backups-y-amazon-s3/
