#!/usr/bin/env bash
# ==============================================================================
# Descripción: Realiza un backup del directorio del servidor web en formato tar.gz
# Autor: Facu
# ==============================================================================

# Modo estricto de Bash
set -euo pipefail

# --- Constantes Globales ---
TP_ROOT="$HOME/TP-grupo"
WEBSERVER_DIR="$TP_ROOT/webserver"
BACKUP_DIR="$TP_ROOT/backup"
CONFIG_DIR="$HOME/.tp_config"
LAST_BACKUP_FILE="$CONFIG_DIR/last_backup.txt"

# Códigos de salida
EXIT_OK=0
EXIT_ERROR=1

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

# --- Función Principal ---
main() {
    log_info "Iniciando el proceso de backup..."

    # 1. Validar que el directorio origen exista y no esté vacío
    if [ ! -d "$WEBSERVER_DIR" ] || [ -z "$(ls -A "$WEBSERVER_DIR" 2>/dev/null)" ]; then
        log_error "El directorio de origen ($WEBSERVER_DIR) no existe o está vacío. Nada que respaldar."
        exit $EXIT_ERROR
    fi

    # 2. Asegurar que el directorio de destino exista
    if [ ! -d "$BACKUP_DIR" ]; then
        log_info "Creando el directorio de backups en $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
    fi

    # 3. Generar el nombre del archivo según el formato requerido (YYYYMMDD_HHMMSS)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

    log_info "Creando el archivo de respaldo: $BACKUP_NAME..."

    # 4. Crear el archivo comprimido (ocultando el Warning de rutas absolutas de tar con -C)
    if tar -czf "$BACKUP_PATH" -C "$(dirname "$WEBSERVER_DIR")" "$(basename "$WEBSERVER_DIR")"; then
        log_success "Backup creado exitosamente en: $BACKUP_PATH"
        
        # 5. Asegurar que CONFIG_DIR exista y actualizar el archivo de último backup
        mkdir -p "$CONFIG_DIR"
        echo "$BACKUP_PATH" > "$LAST_BACKUP_FILE"
        log_info "Registro de último backup actualizado."
    else
        log_error "Ocurrió un error al intentar crear el archivo tar.gz."
        exit $EXIT_ERROR
    fi

    exit $EXIT_OK
}

# Ejecutar main
main