#!/usr/bin/env bash
set -euo pipefail

# source "ruta/a/tus/helpers.sh" # Descomentá para cargar validar_password y los logs

PASSWORD_FILE="$HOME/.tp_config/password.hash"

validar_password

read -s -p "Ingrese la nueva password: " pass1
echo # Imprime un salto de línea necesario después de read -s

read -s -p "Confirme la nueva password: " pass2
echo

if [ "$pass1" != "$pass2" ]; then
    log_error "Las contraseñas no coinciden"
    exit 1
fi

nuevo_hash=$(echo -n "$pass1" | sha256sum | cut -d' ' -f1)

echo "$nuevo_hash" > "$PASSWORD_FILE"

log_success "La password fue cambiada exitosamente"