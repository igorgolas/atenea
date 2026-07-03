#!/usr/bin/env bash
set -euo pipefail

CURSOR_DIR="${HOME}/.cursor"
MCP_FILE="${CURSOR_DIR}/mcp.json"
SOURCE_FILE="$(cd "$(dirname "$0")" && pwd)/mcp-atenea-global.json"

mkdir -p "${CURSOR_DIR}"

python3 - "${SOURCE_FILE}" "${MCP_FILE}" <<'PY'
import json
import sys
from pathlib import Path

source = json.loads(Path(sys.argv[1]).read_text())
target_path = Path(sys.argv[2])

if target_path.exists():
    target = json.loads(target_path.read_text())
else:
    target = {}

target.setdefault("mcpServers", {})
target["mcpServers"]["mcp atenea"] = source["mcpServers"]["mcp atenea"]

target_path.write_text(json.dumps(target, indent=2) + "\n")
print(f"OK: mcp atenea instalado en {target_path}")
PY

echo
echo "Siguiente:"
echo "  1. Reinicia Cursor (Cmd/Ctrl+Shift+P -> Reload Window)"
echo "  2. Settings -> MCP -> verifica que 'mcp atenea' aparece en verde"
echo "  3. Antes de usarlo, abre el tunel SSH:"
echo "     ssh -i ~/.ssh/ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4"
