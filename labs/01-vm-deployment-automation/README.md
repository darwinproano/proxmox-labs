# Lab 01 — VM Deployment & Automation

### Proxmox VE · Ubuntu Cloud Image · Cloud-Init · CLI · REST API · VS Code

**Autor:** Darwin Proaño Orellana  
**Serie:** Proxmox VE Engineering Labs

---

## 🎯 Objetivo

Este laboratorio documenta diferentes métodos de creación y aprovisionamiento de máquinas virtuales en **Proxmox VE**, partiendo desde métodos tradicionales de administración hasta automatización mediante API.

El objetivo fue comprender progresivamente el flujo de aprovisionamiento:

**GUI → CLI → Cloud Image → Cloud-Init → REST API → Automation**

El laboratorio fue desarrollado en un entorno de pruebas sobre **Proxmox VE 9.2 ejecutándose dentro de VMware Workstation**, utilizando una imagen cloud de Ubuntu Server.

---

## 🧪 Escenario del laboratorio

El entorno utilizado para esta práctica incluye:

- Proxmox VE 9.2
- VMware Workstation
- Ubuntu Server 24.04 Cloud Image
- Cloud-Init
- Proxmox CLI (`qm`)
- Proxmox REST API
- Visual Studio Code
- REST Client Extension

El laboratorio fue diseñado para practicar diferentes métodos de aprovisionamiento y documentar el proceso completo de implementación.

---

## 🏗️ Arquitectura general

```text
Windows 11 Host
│
└── VMware Workstation
    │
    └── Proxmox VE 9.2
        │
        ├── vmbr0 → NAT / Internet
        │
        ├── vmbr1 → Internal Lab Network
        │
        └── dstore1-vms
            │
            ├── Ubuntu Cloud Image
            ├── VM 100
            └── VM 101
