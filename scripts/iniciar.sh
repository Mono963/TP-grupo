#!/usr/bin/env bash
set -euo pipefail

#Constantes de los nombres de los contenedores
CONTAINER_WEB="tp_webserver"
CONTAINER_FTP="tp_ftpserver"

#Funciones de Ayuda Visual (Loggeo)
log_info() {
    echo -e "[INFO] $1"
}

log_success() {
    echo -e "[OK] $1"
}

log_error() {
    echo -e "[ERROR] $1" >&2
}

# Función para mostrar la ayuda del script
mostrar_ayuda() {
    echo "Uso: $0 [docker1 | docker2 | todos]"
    echo "Ejemplos:"
    echo "  $0 docker1  -> Inicia solo el servidor Apache"
    echo "  $0 docker2  -> Inicia solo el servidor FTP"
    echo "  $0 todos    -> Inicia ambos servidores"
}

# Función que maneja la lógica de levantar un contenedor
levantar_contenedor() {
    local nombre_contenedor=$1
    local comando_run=$2

    log_info "Verificando el contenedor: ${nombre_contenedor}..."
    
    # Comprobar si el contenedor existe (activo o apagado)
    if [ "$(docker ps -a --filter "name=^${nombre_contenedor}$" --format '{{.Names}}')" == "${nombre_contenedor}" ]; then
        log_info "El contenedor '${nombre_contenedor}' ya existe. Iniciando con 'docker start'..."
        if docker start "${nombre_contenedor}" > /dev/null; then
            log_success "Contenedor '${nombre_contenedor}' iniciado con éxito."
        else
            log_error "No se pudo iniciar el contenedor '${nombre_contenedor}'."
            return 1
        fi
    else
        log_info "El contenedor '${nombre_contenedor}' no existe. Creando con 'docker run'..."
        if eval "$comando_run" > /dev/null; then
            log_success "Contenedor '${nombre_contenedor}' creado e iniciado con éxito."
        else
            log_error "Error al ejecutar docker run para '${nombre_contenedor}'."
            return 1
        fi
    fi
}

# 3. Validación: Si no recibe argumentos
if [ $# -eq 0 ]; then
    log_error "Faltan argumentos."
    mostrar_ayuda
    exit 2
fi

# 4. Convertir el primer argumento a minúsculas
ARGUMENTO="${1,,}"

# Definición de los comandos docker run completos
RUN_WEB="docker run -d --name $CONTAINER_WEB -p 80:80 -p 443:443 -v \$HOME/TP-grupo/webserver:/usr/local/apache2/htdocs/ httpd:2.4-alpine"
RUN_FTP="docker run -d --name $CONTAINER_FTP -p 21:21 -p 30000-30009:30000-30009 -e PUBLICHOST=localhost -e FTP_USER_NAME=tpuser -e FTP_USER_PASS=tppass2025 -e FTP_USER_HOME=/home/tpuser -v \$HOME/TP-grupo/webserver:/home/tpuser stilliard/pure-ftpd"

# 5. Validación de argumentos válidos y ejecución
case "${ARGUMENTO}" in
    "docker1")
        levantar_contenedor "$CONTAINER_WEB" "$RUN_WEB"
        ;;
    "docker2")
        levantar_contenedor "$CONTAINER_FTP" "$RUN_FTP"
        ;;
    "todos")
        levantar_contenedor "$CONTAINER_WEB" "$RUN_WEB"
        levantar_contenedor "$CONTAINER_FTP" "$RUN_FTP"
        ;;
    *)
        log_error "Argumento no válido: '${1}'"
        mostrar_ayuda
        exit 2
        ;;
esac

exit 0