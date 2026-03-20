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

### Gate de salida S2

- Restauracion validada en entorno local.
- Procedimiento de rollback documentado y probado.
- Evidencia de recuperacion con tiempos observados.

## Fase S3 (4-8 semanas) - Confiabilidad y capacidad

### Alcance

- Baseline de performance (lectura, escritura, joins criticos).
- Observabilidad de salud DB (latencia, locks, crecimiento).
- Endurecimiento de seguridad (privilegios, secretos, auditoria de accesos).

### Gate de salida S3

- Umbrales de performance definidos y medidos.
- Alertas minimas activas para eventos criticos.
- Matriz de permisos revisada y aplicada.

## Mapa de trazabilidad con backlog vigente

| Backlog | Fase roadmap | Estado actual |
|---------|--------------|---------------|
| BR-001 | S1 | Implementado |
| BR-002 | S1 | Implementado |
| BR-003 | S1 | En seguimiento |
| BR-004 | S1 | Implementado |
| BR-005 | S1 | Implementado |

## Regla de ejecucion

Ninguna fase avanza sin evidencia concreta en `docs/validacion/` y sin pasar el
gate operativo aplicable.

