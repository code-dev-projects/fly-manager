# Roadmap de Estabilizacion DB (Nivel Arquitecto Senior)

## Objetivo

Convertir el release congelado en una plataforma de datos estable, auditable y
operable en condiciones reales, manteniendo continuidad con el plan vigente y el
backlog post-release.

## Principio de continuidad

- No reabrir discusiones ya cerradas del modelo canonico.
- Ejecutar mejoras sobre el release congelado como baseline.
- Cada mejora debe tener gate y evidencia verificable.

## Fase S1 (0-10 dias) - Estabilizacion inmediata

### Alcance

- BR-003: higiene de nomenclatura residual (sin tocar artefactos historicos Fase 0).
- BR-004: consolidacion de evidencia de release con plantilla unica.
- BR-005: regresion SQL post-seed automatizada.

### Entregables

- Script de regresion SQL y ejecucion automatica.
- Plantilla estandar de evidencia de corte.
- Checklist actualizado con controles tecnicos adicionales.

### Gate de salida S1

- Gate integral `infra/tools/ejecutar_gate_pre_release.ps1` en verde.
- `infra/tools/validar_rutas_docs.ps1` sin referencias faltantes.
- Regresion SQL post-seed sin fallas.

## Fase S2 (2-4 semanas) - Gobierno operativo

### Alcance

- Politica de migraciones versionadas y rollback controlado.
- Estrategia de backup/restore con prueba de recuperacion.
- Runbooks operativos para incidentes de datos.

### Avance S2.1 (2026-03-19)

- Estructura `db/migrations/up` y `db/migrations/down` definida con bootstrap del
  journal de migraciones.
- Scripts operativos creados:
  - `infra/tools/validar_migraciones.ps1`
  - `infra/tools/aplicar_migraciones.ps1`
  - `infra/tools/revertir_ultima_migracion.ps1`
- Politica formal documentada en:
  - `docs/validacion/POLITICA_MIGRACIONES_Y_ROLLBACK.md`
- Gate `infra/tools/ejecutar_gate_pre_release.ps1` reforzado con validacion de
  migraciones versionadas.

### Avance S2.2 (2026-03-19)

- Estrategia local de backup/restore definida y documentada en:
  - `docs/validacion/POLITICA_BACKUP_RESTORE_Y_RECUPERACION.md`
- Scripts operativos creados:
  - `infra/tools/generar_backup_local.ps1`
  - `infra/tools/restaurar_backup_local.ps1`
  - `infra/tools/ejecutar_prueba_recuperacion_local.ps1`
- Evidencia validada y publicada en:
  - `docs/validacion/EVIDENCIA_RECUPERACION_LOCAL_2026-03-19.md`

### Avance S2.3 (2026-03-19)

- Script de diagnostico rapido creado:
  - `infra/tools/diagnosticar_postgres_local.ps1`
- Runbook operativo inicial documentado en:
  - `docs/validacion/RUNBOOK_INCIDENTES_DATOS_LOCAL.md`

### Gate de salida S2

- Restauracion validada en entorno local.
- Procedimiento de rollback documentado y probado.
- Evidencia de recuperacion con tiempos observados.

## Fase S3 (4-8 semanas) - Confiabilidad y capacidad

### Alcance

- Baseline de performance (lectura, escritura, joins criticos).
- Observabilidad de salud DB (latencia, locks, crecimiento).
- Endurecimiento de seguridad (privilegios, secretos, auditoria de accesos).

### Avance S3.1 (2026-03-19)

- Politica local de baseline y observabilidad documentada en:
  - `docs/validacion/POLITICA_BASELINE_PERFORMANCE_Y_OBSERVABILIDAD.md`
- Script de baseline performance creado:
  - `infra/tools/ejecutar_baseline_performance_local.ps1`

### Avance S3.2 (2026-03-19)

- Script de snapshot de observabilidad creado:
  - `infra/tools/capturar_observabilidad_local.ps1`
- Runbook de incidentes actualizado para incluir observabilidad minima.

### Avance S3.3 (2026-03-20)

- Politica de seguridad local documentada en:
  - `docs/validacion/POLITICA_SEGURIDAD_DB_LOCAL.md`
- Matriz de privilegios definida en:
  - `docs/validacion/MATRIZ_PRIVILEGIOS_DB_LOCAL.md`
- Scripts operativos creados:
  - `infra/tools/endurecer_seguridad_postgres_local.ps1`
  - `infra/tools/auditar_seguridad_postgres_local.ps1`
- Evidencia de auditoria publicada en:
  - `docs/validacion/EVIDENCIA_AUDITORIA_SEGURIDAD_LOCAL_2026-03-20.md`

### Gate de salida S3

- Umbrales de performance definidos y medidos.
- Alertas minimas activas para eventos criticos.
- Matriz de permisos revisada y aplicada.

## Fase S4 (8-10 semanas) - Continuidad operativa

### Alcance

- Gestion local de secretos no versionados.
- Gates de continuidad para evitar drift operativo.
- Reduccion progresiva de riesgos residuales del entorno local.

### Avance S4.1 (2026-03-20) - Implementado y validado

- Politica de secretos locales documentada en:
  - `docs/validacion/POLITICA_SECRETOS_LOCALES_Y_ROTACION.md`
- Scripts operativos creados:
  - `infra/tools/inicializar_secretos_locales.ps1`
  - `infra/tools/validar_secretos_locales.ps1`
- Gate `infra/tools/ejecutar_gate_pre_release.ps1` reforzado con validacion de
  secreto local antes de ejecutar Docker.
- `infra/docker/recrear_instalacion_limpia.ps1` reforzado para bloquear si
  `infra/docker/.env` no existe o sigue usando placeholder.
- Evidencia publicada y validada en:
  - `docs/validacion/EVIDENCIA_SECRETOS_LOCALES_2026-03-20.md`
  - `docs/validacion/EVIDENCIA_AUDITORIA_SEGURIDAD_LOCAL_2026-03-20.md`
- Resultado:
  - `infra/docker/.env` local presente, no versionado y validado.
  - El secreto runtime local ya no usa placeholder.
  - Riesgos residuales del entorno local reducidos a 2.

### Avance S4.2 (2026-03-20) - Implementado y validado

- Provision de logins operativos locales documentada e integrada al flujo:
  - `infra/tools/provisionar_logins_operativos_locales.ps1`
  - `infra/tools/validar_logins_operativos_locales.ps1`
- `infra/docker/.env.example` y `infra/docker/.env` ampliados para contener
  credenciales locales RW, RO y AUDIT no versionadas.
- `infra/docker/recrear_instalacion_limpia.ps1` reforzado para provisionar y
  validar logins operativos despues del hardening.
- Gate `infra/tools/ejecutar_gate_pre_release.ps1` reforzado con validacion de
  logins operativos locales.
- Evidencia publicada y validada en:
  - `docs/validacion/EVIDENCIA_LOGINS_OPERATIVOS_LOCALES_2026-03-20.md`
- Resultado:
  - El uso cotidiano local ya no depende solo de `fly_admin`.
  - RW, RO y AUDIT quedan conectables con password y roles heredados.
  - `fly_admin` permanece como riesgo residual controlado solo para bootstrap,
    migracion y administracion.

### Avance S4.3 (2026-03-20) - Implementado y validado

- Menor privilegio operativo integrado al flujo y al gate:
  - `infra/tools/validar_menor_privilegio_operativo_local.ps1`
- `infra/tools/diagnosticar_postgres_local.ps1` y
  `infra/tools/capturar_observabilidad_local.ps1` ahora resuelven por defecto
  `FLY_APP_AUDIT_USER`.
- `infra/tools/ejecutar_baseline_performance_local.ps1` separa lectura y
  escritura: lecturas con `FLY_APP_RO_USER` y probe temporal con
  `FLY_APP_RW_USER`.
- `infra/tools/endurecer_seguridad_postgres_local.ps1` habilita `TEMP`
  solamente para el rol RW, manteniendo RO y AUDIT sin ese privilegio.
- Evidencia publicada y validada en:
  - `docs/validacion/EVIDENCIA_MENOR_PRIVILEGIO_OPERATIVO_LOCAL_2026-03-20.md`
- Resultado:
  - Diagnostico, observabilidad y baseline ya no degradan a `fly_admin`.
  - Se validaron `3` flujos no administrativos con `0` fallas bloqueantes.
  - Riesgos residuales permanecen en `fly_admin` superuser y puerto local expuesto.

### Gate de salida S4

- `infra/docker/.env` presente y no versionado.
- Placeholder eliminado del secreto runtime local.
- Gate arquitectonico bloquea si el secreto local es invalido.
- Logins operativos locales provisionados y validados por conexion real.
- Diagnostico, observabilidad y baseline operan por defecto con AUDIT/RO/RW.
- Riesgos residuales reducidos y documentados.

## Mapa de trazabilidad con backlog vigente

| Backlog | Fase roadmap | Estado actual |
|---------|--------------|---------------|
| BR-001 | S1 | Implementado |
| BR-002 | S1 | Implementado |
| BR-003 | S1 | Implementado |
| BR-004 | S1 | Implementado |
| BR-005 | S1 | Implementado |

## Regla de ejecucion

Ninguna fase avanza sin evidencia concreta en `docs/validacion/` y sin pasar el
gate operativo aplicable.
