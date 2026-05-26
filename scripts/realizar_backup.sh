#!/usr/bin/env bash

set -euo pipefail

readonly TP_ROOT="$HOME/TP-grupo"
readonly WEBSERVER_DIR="$TP_ROOT/webserver"
readonly BACKUP_DIR="$TP_ROOT/backup"
readonly CONFIG_DIR="$HOME/.tp_config"
readonly PASSWORD_FILE="$CONFIG_DIR/password.hash"
readonly LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

readonly EXIT_OK=0
readonly EXIT_ERROR=1
readonly EXIT_WRONG_PASSWORD=3

log_info()    { echo "[INFO] $*"; }
log_success() { echo "[OK] $*"; }
log_error()   { echo "[ERROR] $*" >&2; }

confirm() {
    local mensaje="${1:-¿Continuar?}"
    local respuesta
    read -r -p "$mensaje [s/N]: " respuesta
    [[ "$respuesta" =~ ^[sS]([iI])?$ ]]
}

validar_password() {
    if [[ ! -f "$PASSWORD_FILE" ]]; then
        log_error "No existe el archivo de password. Corra el setup inicial."
        exit $EXIT_ERROR
    fi
    local input_password input_hash stored_hash
    read -s -r -p "Ingrese la contraseña: " input_password
    echo ""
    input_hash=$(echo -n "$input_password" | sha256sum | cut -d' ' -f1)
    stored_hash=$(cat "$PASSWORD_FILE")
    if [[ "$input_hash" != "$stored_hash" ]]; then
        log_error "Contraseña incorrecta."
        exit $EXIT_WRONG_PASSWORD
    fi
    log_success "Contraseña validada."
}

main() {
    log_info "Iniciando el proceso de backup..."

    validar_password

    if [[ ! -d "$WEBSERVER_DIR" ]] || [[ -z "$(ls -A "$WEBSERVER_DIR" 2>/dev/null)" ]]; then
        log_error "El directorio $WEBSERVER_DIR no existe o está vacío. Nada que respaldar."
        exit $EXIT_ERROR
    fi

    if ! confirm "¿Realizar backup del contenido de $WEBSERVER_DIR?"; then
        log_info "Operación cancelada por el usuario."
        exit $EXIT_OK
    fi

    mkdir -p "$BACKUP_DIR"

    local timestamp backup_name backup_path
    timestamp=$(date +"%Y%m%d_%H%M%S")
    backup_name="backup_${timestamp}.tar.gz"
    backup_path="$BACKUP_DIR/$backup_name"

    log_info "Creando el archivo de respaldo: $backup_name..."

    if tar -czf "$backup_path" -C "$(dirname "$WEBSERVER_DIR")" "$(basename "$WEBSERVER_DIR")"; then
        log_success "Backup creado en: $backup_path"

        mkdir -p "$CONFIG_DIR"
        echo "$(date +%Y-%m-%d)" > "$LAST_BACKUP_FILE"
        echo "$backup_path" >> "$LAST_BACKUP_FILE"
        log_info "Registro de último backup actualizado."
    else
        log_error "Ocurrió un error al crear el archivo tar.gz."
        exit $EXIT_ERROR
    fi

    exit $EXIT_OK
}

main "$@"