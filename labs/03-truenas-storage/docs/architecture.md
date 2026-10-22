# Arquitectura y rutas

- Host Proxmox `pve01` (homelab Ryzen).
- VM TrueNAS SCALE `109`, IP `192.168.18.15`, 4 vCPU, 8 GiB, boot 32 GiB y passthrough de HDD 2 TB.
- Pool ZFS `pool1`; recurso SMB `smb-compartida`; export NFS `nfs-seguridad` a `172.16.20.0/24`.
- Cliente NFS `sec-analyst-01` y acceso SMB desde Windows.
- Destino de backup local: `/mnt/pve/HDD-Backups/TrueNAS-2Backup`.

**Verificar** rutas de datasets, acceso SSH y montajes en el sistema real antes de ejecutar scripts. No se incluyen credenciales ni archivos de producción.

El disco único de 2 TB **no tiene redundancia física**. Los snapshots no sustituyen respaldos independientes.
