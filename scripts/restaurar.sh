#!/usr/bin/env bash
# ==============================================================================
# Descripción: Restaura el servidor web a partir del último backup generado
# Autor: Facu
# ==============================================================================

# Modo estricto de Bash
set -euo pipefail

# --- Constantes Globales ---
TP_ROOT="$HOME/TP-grupo"
WEBSERVER_DIR="$TP_ROOT/webserver"
CONFIG_DIR="$HOME/.tp_config"
PASSWORD_FILE="$CONFIG_DIR/password.hash"
LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

# Códigos de salida
EXIT_OK=0
EXIT_ERROR=1
EXIT_INVALID_ARGS=2
EXIT_WRONG_PASSWORD=3

# --- Funciones Helper ---
log_info() {
    echo -e "[\e[34mINFO\e[0m] $1"
}

log_success() {
    echo -e "[\e[32mOK\e[0m] $1"
}

log_error() {
    echo -e "[\e[31mERROR\e[0m] $1" >&2
}

validar_password() {
    if [ ! -f "$PASSWORD_FILE" ]; then
        log_error "El sistema de contraseñas no está inicializado. Falta password.hash."
        exit $EXIT_ERROR
    fi

    echo -n "Ingrese la contraseña de administrador: "
    read -rs INPUT_PASS
    echo "" # Salto de línea estético después del input oculto

    # Calcular el hash de la entrada y compararlo con el guardado
    INPUT_HASH=$(echo -n "$INPUT_PASS" | sha256sum | cut -d' ' -f1)
    SAVED_HASH=$(cat "$PASSWORD_FILE")

    if [ "$INPUT_HASH" != "$SAVED_HASH" ]; then
        log_error "Contraseña incorrecta."
        exit $EXIT_WRONG_PASSWORD
    fi
    log_success "Contraseña validada con éxito."
}

# --- Función Principal ---
main() {
    log_info "Iniciando el proceso de restauración..."

    # 1. Control de seguridad por contraseña
    validar_password

    # 2. Verificar si existe el registro del último backup
    if [ ! -f "$LAST_BACKUP_FILE" ]; then
        log_error "No se encontró el archivo $LAST_BACKUP_FILE. No hay registro de backups previos."
        exit $EXIT_ERROR
    fi

    # 3. Leer la ruta del backup y verificar que el archivo físico realmente exista
    BACKUP_PATH=$(cat "$LAST_BACKUP_FILE")

    if [ -z "$BACKUP_PATH" ] || [ ! -f "$BACKUP_PATH" ]; then
        log_error "El archivo de backup apuntado ($BACKUP_PATH) no existe o está corrupto."
        exit $EXIT_ERROR
    fi

    log_info "Se encontró el último backup en: $BACKUP_PATH"
    log_info "Atención: Esto sobrescribirá el contenido actual de $WEBSERVER_DIR."
    
    # 4. Confirmación interactiva de seguridad
    echo -n "¿Está seguro que desea continuar con la restauración? (s/n): "
    read -r CONFIRMATION
    if [[ ! "$CONFIRMATION" =~ ^[sS]$ ]]; then
        log_info "Operación cancelada por el usuario."
        exit $EXIT_OK
    fi

    # 5. Limpiar el directorio actual antes de extraer para evitar archivos residuales
    if [ -d "$WEBSERVER_DIR" ]; then
        log_info "Limpiando directorio webserver actual..."
        rm -rf "$WEBSERVER_DIR/*"
    else
        mkdir -p "$WEBSERVER_DIR"
    fi

    # 6. Extraer el contenido del backup en la raíz del proyecto
    log_info "Extrayendo archivos..."
    if tar -xzf "$BACKUP_PATH" -C "$(dirname "$WEBSERVER_DIR")"; then
        log_success "Restauración completada con éxito."
    else
        log_error "Ocurrió un error crítico durante la extracción del archivo."
        exit $EXIT_ERROR
    fi

    exit $EXIT_OK
}

# Ejecutar main
main