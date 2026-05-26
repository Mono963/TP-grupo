#!/usr/bin/env bash

set -euo pipefail

readonly CONFIG_DIR="$HOME/.tp_config"
readonly LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

readonly EXIT_OK=0
readonly EXIT_ERROR=1

log_info()    { echo "[INFO] $*"; }
log_success() { echo "[OK] $*"; }
log_error()   { echo "[ERROR] $*" >&2; }

main() {
    if [[ ! -f "$LAST_BACKUP_FILE" ]]; then
        log_info "Aún no se realizó ningún backup."
        exit $EXIT_OK
    fi

    local fecha_backup fecha_actual ts_backup ts_actual dias
    fecha_backup=$(sed -n '1p' "$LAST_BACKUP_FILE")

    if [[ -z "$fecha_backup" ]]; then
        log_error "El registro de backup no contiene una fecha válida."
        exit $EXIT_ERROR
    fi

    fecha_actual=$(date +%Y-%m-%d)

    ts_backup=$(date -d "$fecha_backup" +%s)
    ts_actual=$(date -d "$fecha_actual" +%s)

    dias=$(( (ts_actual - ts_backup) / 86400 ))

    if [[ "$dias" -eq 0 ]]; then
        log_success "El último backup se hizo hoy."
    elif [[ "$dias" -eq 1 ]]; then
        log_success "Pasó 1 día desde el último backup."
    else
        log_success "Días desde el último backup: $dias"
    fi

    exit $EXIT_OK
}

main "$@"