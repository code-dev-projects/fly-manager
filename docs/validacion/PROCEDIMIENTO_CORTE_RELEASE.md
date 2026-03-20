# Procedimiento de Corte para Release (Operativo)

## Objetivo

Estandarizar el cierre tecnico previo al commit/tag final, dejando trazabilidad
de validaciones y evidencia de corte.

## Precondiciones

- Estar en la rama de trabajo de release/pre-release.
- Tener Docker operativo (si se ejecutara validacion completa).
- Tener cambios listos para commit (el commit lo realiza el responsable Git).

## Paso 1. Ejecutar gate integral

Validacion completa (recomendada):

```powershell
.\infra\tools\ejecutar_gate_pre_release.ps1
```

Validacion solo documental (si no deseas ejecutar Docker en ese momento):

```powershell
.\infra\tools\ejecutar_gate_pre_release.ps1 -SkipDocker
```

## Paso 2. Verificar estado de trabajo antes de commit

```powershell
git status -sb
git diff --stat
```

## Paso 3. Commit manual (responsable Git)

Ejemplo de commit:

```powershell
git add .
git commit -m "chore(release): cierre pre-release arquitectonico y gate operativo"
```

## Paso 4. Registrar hash/fecha en nota ejecutiva

Actualizar:

- `docs/planes/NOTA_EJECUTIVA_PRE_RELEASE_2026-03-19.md`

Campos a completar:

- Rama de integracion
- Hash del commit
- Fecha/hora del commit
- Responsable

## Paso 5. Verificacion final post-commit

```powershell
git log -1 --oneline
```

El hash de `git log -1` debe coincidir con el registrado en la nota ejecutiva.

