param(
    [switch]$SkipDocker,
    [switch]$IncludeCodePaths
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$dockerScript = Join-Path $repoRoot "infra\docker\recrear_instalacion_limpia.ps1"
$docsScript = Join-Path $repoRoot "infra\tools\validar_rutas_docs.ps1"
$checklistPath = Join-Path $repoRoot "docs\validacion\CHECKLIST_RELEASE_ARQUITECTONICO.md"
$notePath = Join-Path $repoRoot "docs\planes\NOTA_EJECUTIVA_PRE_RELEASE_2026-03-19.md"

function Invoke-Step {
    param(
        [string]$Label,
        [scriptblock]$Action
    )

    Write-Host ""
    Write-Host ("[GATE] {0}" -f $Label)
    & $Action
    Write-Host ("[OK] {0}" -f $Label)
}

function Assert-FileExists {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Archivo requerido no encontrado: $Path"
    }
}

function Assert-TextFound {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    if (-not (Select-String -Path $Path -Pattern $Pattern -Quiet)) {
        throw $Message
    }
}

Write-Host ""
Write-Host "======================================================"
Write-Host "  FLY Manager - Gate de Pre-Release Arquitectonico"
Write-Host "======================================================"
Write-Host ("  Repo: {0}" -f $repoRoot)
Write-Host ""

Invoke-Step -Label "Verificacion de archivos base" -Action {
    Assert-FileExists -Path $docsScript
    Assert-FileExists -Path $checklistPath
    Assert-FileExists -Path $notePath
    if (-not $SkipDocker) {
        Assert-FileExists -Path $dockerScript
    }
}

if (-not $SkipDocker) {
    Invoke-Step -Label "Validacion tecnica DDL + seeds + gates" -Action {
        & $dockerScript
        if ($LASTEXITCODE -ne 0) {
            throw "Fallo la validacion tecnica de datos."
        }
    }
} else {
    Write-Host "[WARN] Se omitio la validacion Docker por parametro -SkipDocker."
}

Invoke-Step -Label "Validacion de rutas documentales" -Action {
    if ($IncludeCodePaths) {
        & $docsScript -IncludeCodePaths
    } else {
        & $docsScript
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo la validacion de rutas documentales."
    }
}

Invoke-Step -Label "Chequeo de consistencia documental minima" -Action {
    Assert-TextFound `
        -Path $checklistPath `
        -Pattern "APTO PARA PRE-RELEASE" `
        -Message "El checklist no refleja estado APTO PARA PRE-RELEASE."

    Assert-TextFound `
        -Path $checklistPath `
        -Pattern 'Bloqueantes abiertos:\s*`0`' `
        -Message "El checklist no refleja bloqueantes en cero."

    Assert-TextFound `
        -Path $notePath `
        -Pattern "APTO PARA PRE-RELEASE" `
        -Message "La nota ejecutiva no refleja estado APTO PARA PRE-RELEASE."
}

Write-Host ""
Write-Host "======================================================"
Write-Host "  GATE PRE-RELEASE: OK"
Write-Host "  Siguiente paso: commit manual + registrar hash/fecha"
Write-Host "======================================================"
Write-Host ""
Write-Host "Comando sugerido para corte rapido:"
Write-Host "  .\infra\tools\ejecutar_gate_pre_release.ps1"
Write-Host ""
Write-Host "Comando sugerido si quieres omitir Docker y validar solo documental:"
Write-Host "  .\infra\tools\ejecutar_gate_pre_release.ps1 -SkipDocker"
Write-Host ""
Write-Host "Auditoria estricta opcional (puede reportar referencias historicas como faltantes):"
Write-Host "  .\infra\tools\ejecutar_gate_pre_release.ps1 -SkipDocker -IncludeCodePaths"
