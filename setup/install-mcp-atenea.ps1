$CursorDir = Join-Path $env:USERPROFILE ".cursor"
$McpFile = Join-Path $CursorDir "mcp.json"
$SourceFile = Join-Path $PSScriptRoot "mcp-atenea-global.json"

New-Item -ItemType Directory -Force -Path $CursorDir | Out-Null

$source = Get-Content $SourceFile -Raw | ConvertFrom-Json

if (Test-Path $McpFile) {
  $target = Get-Content $McpFile -Raw | ConvertFrom-Json
} else {
  $target = [pscustomobject]@{ mcpServers = @{} }
}

if (-not $target.mcpServers) {
  $target | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([pscustomobject]@{})
}

$target.mcpServers | Add-Member -NotePropertyName "mcp atenea" -NotePropertyValue $source.mcpServers."mcp atenea" -Force

$target | ConvertTo-Json -Depth 10 | Set-Content -Path $McpFile -Encoding UTF8

Write-Host "OK: mcp atenea instalado en $McpFile"
Write-Host ""
Write-Host "Siguiente:"
Write-Host "  1. Reinicia Cursor"
Write-Host "  2. Settings -> MCP -> verifica que 'mcp atenea' aparece en verde"
Write-Host "  3. Antes de usarlo, abre el tunel SSH:"
Write-Host "     ssh -i $env:USERPROFILE\.ssh\ssh-key-Pe9.key -L 5432:localhost:5432 -l opc 138.2.131.4"
