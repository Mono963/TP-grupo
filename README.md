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

| Persona   | Responsable de                                                       |
| --------- | -------------------------------------------------------------------- |
| Lucio     | Docker, VM, infraestructura, code review                             |
| Persona 2 | scripts/iniciar.sh + scripts/detener.sh                              |
| Persona 3 | scripts/realizar_backup.sh + scripts/restaurar.sh                    |
| Persona 4 | scripts/consultar_dias.sh + scripts/cambiar_password.sh + HTML + PDF |

## Flujo de trabajo Git

1. Cada uno trabaja en su propia rama: `git checkout -b feat/mi-script`
2. Al terminar, sube su rama y abre un Pull Request en GitHub
3. Lucio revisa y mergea a `main`
4. Nadie commitea directo a `main`
