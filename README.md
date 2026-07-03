# atenea

## Túnel SSH a PostgreSQL

```bash
chmod 400 ~/.ssh/ssh-key-Pe9.key
ssh -i ~/.ssh/ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4
```

Deja esa terminal abierta mientras uses la base de datos.

## MCP **mcp atenea** (Cursor)

1. Abre esta carpeta como proyecto en Cursor (debe existir `.cursor/mcp.json` en la raíz).
2. Arranca el túnel SSH **antes** de usar el MCP.
3. Ve a **Cursor → Settings → MCP** y activa **mcp atenea**.
4. Si no aparece, pulsa **Refresh** en MCP o reinicia Cursor.
5. El servidor debe quedar en verde. Si está en rojo, el túnel no está activo o el puerto 5432 no responde.

La connection string va directamente en `.cursor/mcp.json`:

```
postgres://creditor2_lector:***@localhost:5432/creddb2
```
