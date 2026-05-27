#!/usr/bin/env bash

set -euo pipefail


readonly TP_ROOT="$HOME/TP-grupo"
readonly WEBSERVER_DIR="$TP_ROOT/webserver"
readonly BACKUP_DIR="$TP_ROOT/backup"
readonly CONFIG_DIR="$HOME/.tp_config"
readonly PASSWORD_FILE="$CONFIG_DIR/password.hash"
readonly LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

readonly CONTAINER_WEB="tp_webserver"
readonly CONTAINER_FTP="tp_ftpserver"

readonly EXIT_OK=0
readonly EXIT_ERROR=1
readonly EXIT_INVALID_ARGS=2
readonly EXIT_WRONG_PASSWORD=3

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[OK] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

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
    log_info "Iniciando $(basename "$0")..."

    log_success "Finalizado correctamente."
    exit $EXIT_OK
}

main "$@"
