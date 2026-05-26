#!/usr/bin/env bash

set -euo pipefail

readonly CONFIG_DIR="$HOME/.tp_config"
readonly PASSWORD_FILE="$CONFIG_DIR/password.hash"

readonly EXIT_OK=0
readonly EXIT_ERROR=1
readonly EXIT_WRONG_PASSWORD=3

log_info()    { echo "[INFO] $*"; }
log_success() { echo "[OK] $*"; }
log_error()   { echo "[ERROR] $*" >&2; }

validar_password() {
    if [[ ! -f "$PASSWORD_FILE" ]]; then
        log_error "No existe el archivo de password. Corra el setup inicial."
        exit $EXIT_ERROR
    fi
    local input_password input_hash stored_hash
    read -s -r -p "Ingrese la contraseña actual: " input_password
    echo ""
    input_hash=$(echo -n "$input_password" | sha256sum | cut -d' ' -f1)
    stored_hash=$(cat "$PASSWORD_FILE")
    if [[ "$input_hash" != "$stored_hash" ]]; then
        log_error "Contraseña incorrecta."
        exit $EXIT_WRONG_PASSWORD
    fi
    log_success "Contraseña actual validada."
}

main() {
    log_info "Cambio de contraseña del sistema."

    validar_password

    local pass1 pass2
    read -s -r -p "Ingrese la nueva contraseña: " pass1
    echo ""
    read -s -r -p "Confirme la nueva contraseña: " pass2
    echo ""

    if [[ -z "$pass1" ]]; then
        log_error "La contraseña no puede estar vacía. No se realizaron cambios."
        exit $EXIT_ERROR
    fi

    if [[ "$pass1" != "$pass2" ]]; then
        log_error "Las contraseñas no coinciden. No se realizaron cambios."
        exit $EXIT_ERROR
    fi
    local nuevo_hash
    nuevo_hash=$(echo -n "$pass1" | sha256sum | cut -d' ' -f1)
    echo "$nuevo_hash" > "$PASSWORD_FILE"
    chmod 600 "$PASSWORD_FILE"

    log_success "La contraseña fue cambiada exitosamente."
    exit $EXIT_OK
}

main "$@"