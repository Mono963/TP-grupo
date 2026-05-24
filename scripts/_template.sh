#!/usr/bin/env bash
# ============================================================
# scripts/nombre_script.sh
# Descripción: [breve descripción de qué hace el script]
# Autor: [Tu nombre]
# Parte del TP Integrador: Bash + Docker
# ============================================================

set -euo pipefail

# ---------- Constantes globales ----------
# (Mantener sincronizado con README.md)

readonly TP_ROOT="$HOME/TP-grupo"
readonly WEBSERVER_DIR="$TP_ROOT/webserver"
readonly BACKUP_DIR="$TP_ROOT/backup"
readonly CONFIG_DIR="$HOME/.tp_config"
readonly PASSWORD_FILE="$CONFIG_DIR/password.hash"
readonly LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

readonly CONTAINER_WEB="tp_webserver"
readonly CONTAINER_FTP="tp_ftpserver"

# Códigos de salida (según convenciones del README)
readonly EXIT_OK=0
readonly EXIT_ERROR=1
readonly EXIT_INVALID_ARGS=2
readonly EXIT_WRONG_PASSWORD=3

# ---------- Funciones helper ----------

log_info() {
    echo "[INFO] $*"
}

log_success() {
    echo "[OK] $*"
}

log_error() {
    # Los errores van a stderr, no a stdout
    echo "[ERROR] $*" >&2
}

# Pide confirmación al usuario. Devuelve 0 si confirmó, 1 si no.
# Uso: if confirm "¿Continuar?"; then ...
confirm() {
    local mensaje="${1:-¿Continuar?}"
    local respuesta
    read -r -p "$mensaje [s/N]: " respuesta
    [[ "$respuesta" =~ ^[sS]([iI])?$ ]]
}

# Valida que la password ingresada coincida con el hash guardado.
# Sale con código 3 si es incorrecta.
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

# ---------- Lógica del script ----------

main() {
    log_info "Iniciando $(basename "$0")..."

    # TODO: implementar la lógica específica del script acá

    log_success "Finalizado correctamente."
    exit $EXIT_OK
}

# Punto de entrada
main "$@"
