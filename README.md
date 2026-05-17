# TP Integrador — Bash + Docker

Servidor web Apache + FTP en contenedores Docker, gestionado con scripts Bash.

## Estructura

- `scripts/` → los 6 scripts del TP
- `webserver/` → contenido HTML que sirve Apache
- `backup/` → backups generados (NO se sube a git)
- `docs/` → PDF de entrega y capturas

## Convenciones del proyecto (NO TOCAR sin avisar al grupo)

Rutas en la VM:

- WEBSERVER_DIR=/home/usuario/webserver
- BACKUP_DIR=/home/usuario/backup
- CONFIG_DIR=/home/usuario/.tp_config
- PASSWORD_FILE=$CONFIG_DIR/password.hash
- LAST_BACKUP_FILE=$CONFIG_DIR/last_backup.txt

Nombres de contenedores:

- docker1 = "tp_webserver" (Apache, puertos 80/443)
- docker2 = "tp_ftpserver" (FTP, puerto 21)

Formato de backup: `backup_YYYYMMDD_HHMMSS.tar.gz`

Todos los scripts arrancan con:
\`\`\`bash
#!/usr/bin/env bash
set -euo pipefail
\`\`\`

## División de tareas

| Persona | Responsable de                                                       |
| ------- | -------------------------------------------------------------------- |
| Lucio   | Docker, VM, infraestructura, code review                             |
| Nahuel  | scripts/iniciar.sh + scripts/detener.sh                              |
| Facu    | scripts/realizar_backup.sh + scripts/restaurar.sh                    |
| Juane   | scripts/consultar_dias.sh + scripts/cambiar_password.sh + HTML + PDF |

## Flujo de trabajo Git

1. Cada uno trabaja en su propia rama: `git checkout -b feat/mi-script`
2. Al terminar, sube su rama y abre un Pull Request en GitHub
3. Lucio revisa y mergea a `main`
4. Nadie commitea directo a `main`

## Setup del entorno (todos los integrantes)

Requisitos:

1. Windows: instalar WSL2 con Ubuntu (`wsl --install -d Ubuntu` en PowerShell admin).
2. Instalar Docker Desktop y activar la integración con WSL2 (Settings → Resources → WSL Integration → activar Ubuntu).
3. Instalar VS Code + extensión "WSL" de Microsoft.
4. Instalar FileZilla (cliente FTP gráfico): https://filezilla-project.org/

Flujo de trabajo:

1. Abrir terminal Ubuntu → ir a la carpeta del repo → ejecutar `code .`
2. Eso abre VS Code conectado a WSL.
3. Trabajar siempre desde la terminal integrada de VS Code (`Ctrl + ñ`).
4. Si en la terminal el prompt empieza con `tuNumbre@...` o `usuario@...`, estás en Linux ✅.

Verificar que Docker funciona en tu WSL:
\`\`\`bash
docker --version
docker ps
\`\`\`

# 📌 Flujo de trabajo con Git y GitHub

## ⚠️ IMPORTANTE

- NO trabajar directamente sobre `main`
- NO hacer push directo a `main`
- Todas las modificaciones deben hacerse mediante Pull Requests

---

# 🌳 Flujo de trabajo

## 1) Actualizar el repositorio

Antes de empezar:

```bash
git checkout main
git pull origin main
```

---

## 2) Crear una nueva rama

Crear SIEMPRE una rama nueva para cada funcionalidad o fix.

### Ejemplos:

```bash
git checkout -b feature/login
```

```bash
git checkout -b feature/navbar
```

```bash
git checkout -b fix/error-auth
```

---

## 3) Trabajar normalmente

Agregar cambios:

```bash
git add .
```

Hacer commit:

```bash
git commit -m "feat: se agregó login"
```

---

## 4) Subir la rama

```bash
git push origin nombre-rama
```

Ejemplo:

```bash
git push origin feature/login
```

---

## 5) Crear Pull Request

1. Ir al repositorio en GitHub
2. Abrir un Pull Request hacia `main`
3. Esperar revisión y aprobación

---

# 🚫 NO HACER

## ❌ Nunca trabajar directamente en `main`

NO usar:

```bash
git checkout main
```

para desarrollar funcionalidades.

---

## ❌ Nunca hacer push directo a main

NO usar:

```bash
git push origin main
```

---

# ✅ Naming recomendado para ramas

## Features

```txt
feature/login
feature/dashboard
feature/perfil
```

## Fixes

```txt
fix/navbar
fix/error-auth
```

## Refactors

```txt
refactor/user-service
```

---

# 📌 Convención de commits

## Features

```bash
git commit -m "feat: se agregó login"
```

## Fixes

```bash
git commit -m "fix: se corrigió error de autenticación"
```

## Refactor

```bash
git commit -m "refactor: se mejoró user service"
```

---

# 🔒 Protección de rama

La rama `main` está protegida.

Todos los cambios deben:

- pasar por Pull Request
- ser revisados
- ser aprobados antes de mergearse
