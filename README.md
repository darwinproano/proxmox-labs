# Proxmox VE Engineering Labs

### Infrastructure · Virtualization · Networking · Automation · Security

**Hands-on engineering labs by [Darwin Proaño Orellana](https://github.com/darwinproano)** 🇪🇨

Este repositorio documenta una serie de **laboratorios prácticos de ingeniería sobre Proxmox VE**, desarrollados para explorar escenarios de infraestructura, virtualización, networking, almacenamiento, automatización y seguridad.

El objetivo no es únicamente mostrar configuraciones terminadas, sino documentar el proceso completo: **diseño, implementación, troubleshooting, automatización, resultados y lecciones aprendidas**.

> **From infrastructure fundamentals to automation — learning by building, testing and documenting.**

---

## 🎯 Objetivos del proyecto

Este proyecto busca construir y documentar progresivamente escenarios técnicos relacionados con:

- 🖥️ Virtualización con **Proxmox VE**
- 🌐 Networking y segmentación de redes
- 💾 Arquitecturas de almacenamiento
- 🐧 Integración con Linux
- ☁️ Cloud Images y Cloud-Init
- ⚙️ Automatización de infraestructura
- 🔌 Proxmox REST API
- 🧩 Infrastructure as Code
- 🔐 Seguridad y hardening
- 📦 Backup, recuperación y portabilidad
- 🧪 Troubleshooting y experimentación

Cada laboratorio incluye documentación suficiente para comprender **qué se implementó, por qué se diseñó de esa manera y qué resultados se obtuvieron**.

---

## 🧪 Engineering Labs

| Lab | Proyecto | Estado |
|---|---|---|
| Lab 01 | [VM Deployment — GUI, CLI & REST API Automation](labs/01-vm-deployment-automation/) | 🟢 Published |
| **Lab 02** | Próximo laboratorio / Next Lab | ⚪ Planned |

> El repositorio crecerá progresivamente con nuevos escenarios y tecnologías.

---

## 🚀 Lab 01 — VM Deployment & Automation

### Proxmox VE + Ubuntu Cloud Image + Cloud-Init + REST API

Primer laboratorio de la serie enfocado en diferentes métodos de aprovisionamiento y administración de máquinas virtuales en Proxmox VE.

El laboratorio explora progresivamente:

**GUI → CLI → Cloud Image → Cloud-Init → REST API → Automation**

### Tecnologías

`Proxmox VE` · `Ubuntu Server` · `Cloud Images` · `Cloud-Init` · `Linux` · `REST API` · `VS Code` · `Automation`

### Contenido

- Preparación del entorno Proxmox VE
- Diseño básico de networking
- Configuración de almacenamiento para máquinas virtuales
- Importación de Ubuntu Cloud Image
- Configuración mediante Cloud-Init
- Administración mediante CLI
- Interacción con Proxmox REST API
- Aprovisionamiento automatizado de una VM
- Validación y troubleshooting
- Evidencias de implementación

📁 **[Explore the complete Lab 01 documentation](labs/01-vm-deployment-automation/)**

---

## 🏗️ Arquitectura del repositorio

```text
proxmox-labs/
│
├── README.md
├── .gitignore
│
├── labs/
│   └── 01-vm-deployment-automation/
│       ├── README.md
│       ├── api/
│       ├── scripts/
│       └── images/
│
└── docs/
