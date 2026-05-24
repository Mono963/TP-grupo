#!/usr/bin/env bash
set -euo pipefail

# source "ruta/a/tus/helpers.sh" # Descomentá y ajustá esta línea para cargar tus funciones

BACKUP_FILE="$HOME/.tp_config/last_backup.txt"

if [ ! -f "$BACKUP_FILE" ]; then
    log_info "aun no se realizo ningun backup"
    exit 0
fi

fecha_backup=$(cat "$BACKUP_FILE")
fecha_actual=$(date +%Y-%m-%d)

# Convertir ambas fechas a timestamp Unix (segundos)
ts_backup=$(date -d "$fecha_backup" +%s)
ts_actual=$(date -d "$fecha_actual" +%s)

# Calcular diferencia
diff_segundos=$(( ts_actual - ts_backup ))
dias=$(( diff_segundos / 86400 ))

if [ "$dias" -eq 0 ]; then
    log_success "el backup se hizo hoy"
else
    log_success "Dias desde el ultimo backup: $dias"
fi