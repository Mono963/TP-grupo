## Sistema de password (scripts 1, 3 y 6)

Los scripts que requieren password (realizar_backup.sh, restaurar.sh, cambiar_password.sh)
validan contra un hash SHA-256 guardado en disco.

### Ubicación de archivos

- Directorio: `~/.tp_config/` (permisos 700)
- Archivo de password: `~/.tp_config/password.hash` (permisos 600)

### Setup inicial (cada integrante lo corre UNA vez en su máquina)

\`\`\`bash
mkdir -p ~/.tp_config
chmod 700 ~/.tp_config
echo -n "tp2026admin" | sha256sum | cut -d' ' -f1 > ~/.tp_config/password.hash
chmod 600 ~/.tp_config/password.hash
\`\`\`

Password inicial del TP: `tp2026admin`
(Pueden cambiarla con el script cambiar_password.sh una vez implementado).

### Patrón de validación (para scripts que requieren password)

\`\`\`bash
PASSWORD_FILE="$HOME/.tp_config/password.hash"

if [[! -f "$PASSWORD_FILE"]]; then
echo "Error: no existe el archivo de password. Corra el setup inicial."
exit 1
fi

read -s -p "Ingrese la contraseña: " input_password
echo ""

input_hash=$(echo -n "$input_password" | sha256sum | cut -d' ' -f1)
stored_hash=$(cat "$PASSWORD_FILE")

if [["$input_hash" != "$stored_hash"]]; then
echo "Error: contraseña incorrecta."
exit 3
fi

echo "Contraseña validada."

# ... resto del script ...

\`\`\`

### Importante

- El archivo `password.hash` está fuera del repo y NO se sube a Git (ya está en `.gitignore`).
- Cada uno tiene su propia copia local en su WSL/VM.
- En la VM final de la cátedra se va a configurar una password definitiva.
