# TP Integrador — Bash + Docker

Servidor web Apache + FTP en contenedores Docker, gestionado con scripts Bash.

## Estructura del repo

- `scripts/` → los 6 scripts del TP
- `webserver/` → contenido HTML que sirve Apache
- `backup/` → backups generados (NO se sube a git)
- `docs/` → PDF de entrega y capturas

## División de tareas

| Persona | Responsable de                                                       |
| ------- | -------------------------------------------------------------------- |
| Lucio   | Docker, infraestructura, code review, integración                    |
| Nahuel  | scripts/iniciar.sh + scripts/detener.sh                              |
| Facu    | scripts/realizar_backup.sh + scripts/restaurar.sh                    |
| Juane   | scripts/consultar_dias.sh + scripts/cambiar_password.sh + HTML + PDF |

## Convenciones técnicas (NO TOCAR sin avisar al grupo)

Rutas del proyecto:

- `TP_ROOT="$HOME/TP-grupo"`
- `WEBSERVER_DIR="$TP_ROOT/webserver"`
- `BACKUP_DIR="$TP_ROOT/backup"`
- `CONFIG_DIR="$HOME/.tp_config"`
- `PASSWORD_FILE="$CONFIG_DIR/password.hash"`
- `LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"`

Nombres de contenedores Docker:

- docker1 → `tp_webserver` (Apache, puertos 80/443)
- docker2 → `tp_ftpserver` (FTP, puerto 21)

Formato de backup: `backup_YYYYMMDD_HHMMSS.tar.gz`

Todos los scripts arrancan con:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Códigos de salida estándar:

- 0 = todo OK
- 1 = error genérico
- 2 = argumentos inválidos
- 3 = password incorrecta

## Setup del entorno (todos los integrantes lo hacen una vez)

### Requisitos a instalar

1. **WSL2 con Ubuntu** (solo Windows): abrir PowerShell como administrador y correr `wsl --install -d Ubuntu`. Reiniciar. Crear usuario y contraseña.
2. **Docker Desktop**: descargar de https://www.docker.com/products/docker-desktop/. Después de instalarlo: Settings → Resources → WSL Integration → activar Ubuntu → Apply & Restart.
3. **VS Code**: https://code.visualstudio.com/
4. **Extensión "WSL"** de Microsoft en VS Code (Ctrl+Shift+X → buscar "WSL" → Install).
5. **FileZilla** (cliente FTP): https://filezilla-project.org/

### Cómo abrir el proyecto

Siempre se trabaja desde la terminal de Ubuntu, no desde PowerShell:

```bash
# 1. Abrir Ubuntu desde el menú inicio (o escribir "wsl" en cualquier terminal)
# 2. Ir a la carpeta del repo
cd ~/TP-grupo

# 3. Abrir VS Code conectado a WSL
code .
```

Dentro de VS Code:

- Abrir terminal integrada: `Ctrl + ñ` (o View → Terminal).
- Verificar que el prompt empieza con `tuNombre@...$` (eso confirma que estás en Linux).
- **NO usar nano ni vim** para editar scripts. Crear/editar los archivos directamente en VS Code (con syntax highlighting de Bash).

### Verificar que Docker funciona en tu WSL

```bash
docker --version
docker ps
```

### Setup del sistema de password (una vez)

```bash
mkdir -p ~/.tp_config
chmod 700 ~/.tp_config
echo -n "tp2026admin" | sha256sum | cut -d' ' -f1 > ~/.tp_config/password.hash
chmod 600 ~/.tp_config/password.hash
```

Password inicial del TP: `tp2026admin` (se puede cambiar con `cambiar_password.sh`).

## Template de script

Todos los scripts del TP deben basarse en `scripts/_template.sh`. Este template:

- Define las constantes globales (rutas, nombres de contenedores, códigos de salida).
- Provee funciones helper: `log_info`, `log_success`, `log_error`, `confirm`, `validar_password`.
- Aplica el modo estricto de Bash (`set -euo pipefail`).

### Cómo usarlo

```bash
# 1. Copiar el template con el nombre de tu script
cp scripts/_template.sh scripts/mi_script.sh

# 2. Editar el header (descripción y autor) y la función main()

# 3. Darle permiso de ejecución
chmod +x scripts/mi_script.sh

# 4. Probarlo
./scripts/mi_script.sh
```

NO modificar las funciones helper ni las constantes del template sin avisar al grupo.

## Flujo de trabajo con Git

**Reglas:**

- NO trabajar directamente sobre `main`.
- NO hacer push directo a `main`.
- Todas las modificaciones se hacen mediante Pull Requests.
- Solo Lucio mergea a `main`.

### Pasos para cada feature

```bash
# 1. Antes de empezar, traer lo último
git checkout main
git pull origin main

# 2. Crear rama propia
git checkout -b feat/nombre-script
# Ejemplos: feat/iniciar, feat/backup, feat/cambiar-password

# 3. Trabajar, commitear normalmente
git add .
git commit -m "feat: descripción del cambio"

# 4. Subir la rama
git push origin feat/nombre-script

# 5. Abrir Pull Request en GitHub apuntando a main
# 6. Esperar revisión de Lucio
```

### Convención de commits

- `feat: ...` para nuevas funcionalidades
- `fix: ...` para correcciones de bugs
- `docs: ...` para cambios solo de documentación
- `refactor: ...` para mejoras de código sin cambiar funcionalidad
