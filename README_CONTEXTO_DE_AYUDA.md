## Template de script

Todos los scripts del TP deben basarse en `scripts/_template.sh`. Este template:

- Define las constantes globales (rutas, nombres de contenedores, códigos de salida).
- Provee funciones helper: `log_info`, `log_success`, `log_error`, `confirm`, `validar_password`.
- Aplica el modo estricto de Bash (`set -euo pipefail`).

### Cómo usarlo

\`\`\`bash

# 1. Copiar el template con el nombre de tu script

cp scripts/\_template.sh scripts/mi_script.sh

# 2. Editar el header con la descripción y tu nombre

# 3. Implementar la lógica dentro de la función main()

# 4. Darle permiso de ejecución

chmod +x scripts/mi_script.sh

# 5. Probarlo

./scripts/mi_script.sh
\`\`\`

NO modifiquen las funciones helper ni las constantes del template, salvo que avisen al grupo (esas cosas son compartidas).
