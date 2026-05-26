#!/usr/bin/env bash
set -euo pipefail

readonly TP_ROOT="$HOME/TP-grupo"
readonly WEBSERVER_DIR="$TP_ROOT/webserver"
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
    log_info "Iniciando el proceso de restauración..."

    validar_password

    if [[ ! -f "$LAST_BACKUP_FILE" ]]; then
        log_error "No se encontró $LAST_BACKUP_FILE. No hay backups previos."
        exit $EXIT_ERROR
    fi
    local backup_path
    backup_path=$(sed -n '2p' "$LAST_BACKUP_FILE")

    if [[ -z "$backup_path" ]] || [[ ! -f "$backup_path" ]]; then
        log_error "El backup apuntado ($backup_path) no existe o el registro es inválido."
        exit $EXIT_ERROR
    fi

    log_info "Último backup encontrado: $backup_path"
    log_info "Atención: esto sobrescribirá el contenido de $WEBSERVER_DIR."

    if ! confirm "¿Continuar con la restauración?"; then
        log_info "Operación cancelada por el usuario."
        exit $EXIT_OK
    fi

    if [[ -d "$WEBSERVER_DIR" ]]; then
        log_info "Limpiando directorio actual..."
        rm -rf "${WEBSERVER_DIR:?}"/*
    else
        mkdir -p "$WEBSERVER_DIR"
    fi

    log_info "Extrayendo archivos..."
    if tar -xzf "$backup_path" -C "$(dirname "$WEBSERVER_DIR")"; then
        log_success "Restauración completada con éxito."
    else
        log_error "Error durante la extracción del backup."
        exit $EXIT_ERROR
    fi

    exit $EXIT_OK
}

main "$@"