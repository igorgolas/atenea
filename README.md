# atenea

Conexion **100% local** desde cada ordenador a PostgreSQL remoto (`creddb2`).

No usa Cloud Agents ni conexion desde la nube. Cada PC trabaja en local: Cursor Desktop + tunel SSH + MCP.

## Como funciona (cada ordenador por separado)

```
[Tu PC local]                         [Servidor Oracle 138.2.131.4]
  Cursor Desktop
    -> MCP "mcp atenea" (npx local)
         -> localhost:5432
              -> tunel SSH (-L 5432:localhost:5432)
                   -> PostgreSQL creddb2
```

- **Ordenador A** y **Ordenador B** se configuran igual, pero cada uno abre **su propio tunel SSH**.
- El MCP corre en **tu maquina**, no en Cursor Cloud.
- La connection string apunta a `localhost:5432` porque el tunel reenvia ese puerto al servidor remoto.

## Requisitos (en cada ordenador)

- Cursor Desktop
- Node.js 18+ (`node -v` y `npx -v` deben funcionar)
- Clave SSH en `~/.ssh/ssh-key-Pe9.key` (macOS/Linux) o `%USERPROFILE%\.ssh\ssh-key-Pe9.key` (Windows)

## 1. Tunel SSH (obligatorio antes de usar el MCP)

macOS / Linux:

```bash
chmod 400 ~/.ssh/ssh-key-Pe9.key
ssh -i ~/.ssh/ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4
```

Windows (PowerShell / CMD):

```powershell
ssh -i $env:USERPROFILE\.ssh\ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4
```

Deja esa terminal abierta.

## 2. Instalar MCP global en Cursor (los 2 ordenadores)

El MCP debe ir en la config **global** de Cursor, no solo en el proyecto:

`~/.cursor/mcp.json` (macOS/Linux) o `%USERPROFILE%\.cursor\mcp.json` (Windows)

### Opcion A: enlace directo (mas rapido)

Abre este enlace en cada ordenador (instala el servidor en Cursor):

[Instalar mcp atenea en Cursor](https://cursor.com/install-mcp?name=mcp%20atenea&config=eyJjb21tYW5kIjoibnB4IiwiYXJncyI6WyIteSIsIkBoZW5rZXkvcG9zdGdyZXMtbWNwLXNlcnZlciIsIi0tY29ubmVjdGlvbi1zdHJpbmciLCJwb3N0Z3JlczovL2NyZWRpdG9yMl9sZWN0b3I6dXlkc2gtXzU2ZGlzeXNob0Bsb2NhbGhvc3Q6NTQzMi9jcmVkZGIyIl19)

### Opcion B: script

macOS / Linux:

```bash
bash setup/install-mcp-atenea.sh
```

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File setup/install-mcp-atenea.ps1
```

### Opcion C: manual

Copia el contenido de `setup/mcp-atenea-global.json` dentro de `mcpServers` en tu `~/.cursor/mcp.json`.

Ejemplo final:

```json
{
  "mcpServers": {
    "mcp atenea": {
      "command": "npx",
      "args": [
        "-y",
        "@henkey/postgres-mcp-server",
        "--connection-string",
        "postgres://creditor2_lector:uydsh-_56disysho@localhost:5432/creddb2"
      ]
    }
  }
}
```

## 3. Activar en Cursor (local)

1. Reinicia Cursor (`Cmd/Ctrl+Shift+P` -> **Reload Window**)
2. Ve a **Settings -> MCP** (o **Tools & MCP**)
3. Debe aparecer **mcp atenea** en verde
4. Trabaja en **cualquier proyecto local**; el agente consultara PostgreSQL a traves del tunel de ese PC

> **Importante:** No uses Cloud Agent para consultar la base de datos. Cloud Agent no tiene acceso a tu tunel SSH local. Usa Cursor Desktop en tu ordenador con el tunel activo.

## Si no lo ves

| Problema | Solucion |
|----------|----------|
| No aparece el servidor | Comprueba que existe `~/.cursor/mcp.json` con el bloque de arriba |
| Aparece en rojo | El tunel SSH no esta activo o el puerto 5432 esta ocupado |
| Error de `npx` | Instala Node.js 18+ y reinicia Cursor |
| Duplicado / conflictos | No abras la carpeta `~/.cursor` como proyecto en Cursor |

## Probar conexion (opcional)

Con el tunel activo:

```bash
npx -y @henkey/postgres-mcp-server --connection-string "postgres://creditor2_lector:uydsh-_56disysho@localhost:5432/creddb2"
```

Si arranca sin error, Cursor tambien deberia poder usarlo.
