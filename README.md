# atenea

## Túnel SSH a PostgreSQL

```bash
chmod 400 ~/.ssh/ssh-key-Pe9.key
ssh -i ~/.ssh/ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4
```

Deja esa terminal abierta mientras uses la base de datos.

## MCP PostgreSQL (Cursor)

1. Copia las variables de entorno:

```bash
cp .env.example .env
# Edita .env con la connection string real
```

2. Exporta la variable antes de abrir Cursor (o añádela a tu shell profile):

```bash
export POSTGRES_CONNECTION_STRING="postgres://creditor2_lector:PASSWORD@localhost:5432/creddb2"
```

3. Activa el servidor **mcp atenea** en Cursor → Settings → MCP.

4. Con el túnel SSH activo, el agente podrá consultar `creddb2` en `localhost:5432`.
