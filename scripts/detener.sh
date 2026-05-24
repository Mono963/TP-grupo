#!/usr/bin/env bash
set -euo pipefail

# Constantes de los nombres de los contenedores
CONTAINER_WEB="tp_webserver"
CONTAINER_FTP="tp_ftpserver"

log_info() {
    echo -e "[INFO] $1"
}

log_success() {
    echo -e "[OK] $1"
}

log_error() {
    echo -e "[ERROR] $1" >&2
}

mostrar_ayuda() {
    echo "Uso: $0 [docker1 | docker2 | todos]"
    echo "Ejemplos:"
    echo "  $0 docker1  -> Detiene y elimina el servidor Apache"
    echo "  $0 docker2  -> Detiene y elimina el servidor FTP"
    echo "  $0 todos    -> Detiene y elimina ambos"
}

remover_contenedor() {
    local nombre_contenedor=$1

    log_info "Verificando si el contenedor '${nombre_contenedor}' existe..."
    
    if [ "$(docker ps -a --filter "name=^${nombre_contenedor}$" --format '{{.Names}}')" == "${nombre_contenedor}" ]; then
        log_info "Deteniendo contenedor '${nombre_contenedor}'..."
        docker stop "${nombre_contenedor}" > /dev/null 2>&1 || true
        
        log_info "Eliminando contenedor '${nombre_contenedor}'..."
        if docker rm "${nombre_contenedor}" > /dev/null; then
            log_success "Contenedor '${nombre_contenedor}' removido con éxito."
        else
            log_error "No se pudo eliminar el contenedor '${nombre_contenedor}'."
            return 1
        fi
    else
        log_info "El contenedor '${nombre_contenedor}' no existe. Nada que hacer."
    fi
}

if [ $# -eq 0 ]; then
    log_error "Faltan argumentos."
    mostrar_ayuda
    exit 2
fi

ARGUMENTO="${1,,}"

case "${ARGUMENTO}" in
    "docker1")
        remover_contenedor "$CONTAINER_WEB"
        ;;
    "docker2")
        remover_contenedor "$CONTAINER_FTP"
        ;;
    "todos")
        remover_contenedor "$CONTAINER_WEB"
        remover_contenedor "$CONTAINER_FTP"
        ;;
    *)
        log_error "Argumento no válido: '${1}'"
        mostrar_ayuda
        exit 2
        ;;
esac

exit 0