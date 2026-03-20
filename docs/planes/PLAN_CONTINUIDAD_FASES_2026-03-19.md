# Plan de Continuidad por Fases (Corte 2026-03-19)

## 1. Objetivo

Retomar la ejecucion del paquete arquitectonico FLY con una lectura unica de estado,
evitando contradicciones entre DDL, seeds, reportes y documentos de gobierno.

## 2. Estado del corte (2026-03-19)

- DDL maestro validado en PostgreSQL 16.
- Seed canonico cerrado con flujo E2E funcional.
- Seed volumetrico implementado en capa inicial (no cerrado en metas de volumen).
- Validaciones post-seed disponibles con gate canonico de 6 fases.
- Narrativa documental en proceso de alineacion fina al estado real de avance.

## 3. Estado por fase del Plan Maestro

### Fase 0. Gobierno y baseline

- Estado: Cerrada.
- Evidencia: baseline, matriz de consistencia y plan maestro ya presentes.

### Fase 1. Modelo canonico

- Estado: Cerrada.
- Evidencia: modelo canonico y reglas de normalizacion 3FN documentadas.

### Fase 2. DDL maestro

- Estado: Cerrada.
- Evidencia: `db/ddl/modelo_postgresql.sql` validado sin errores.

### Fase 3. Validacion dura del DDL

- Estado: Cerrada para DDL / En seguimiento para datos volumetricos.
- Evidencia: validacion DDL completa + seed canonico validado.
- Gap: falta cierre de gate volumetrico por cobertura y escala.

### Fase 4. Landing multimedia final

- Estado: En curso.
- Evidencia: landing y reportes navegables.
- Gap: mantener narrativa sincronizada con estado real (volumetrico parcial).

### Fase 5. QA cruzado

- Estado: Pendiente.
- Gap: ejecutar cierre cruzado landing/reportes/docs vs estado real de seeds.

### Fase 6. Release arquitectonico

- Estado: Pendiente.
- Gap: cierre de IE abiertos/en seguimiento + paquete final congelado.

## 4. Brechas activas a cerrar

1. Escalamiento volumetrico incompleto frente a metas de volumen objetivo.
2. Cobertura parcial del flujo de viaje en seed volumetrico (no solo flujo comercial).
3. QA cruzado documental aun abierto para cierre de inconsistencias residuales.

## 5. Plan operativo recomendado (continuacion)

### Tramo A. Cierre tecnico del seed volumetrico

- Expandir `01_seed_volumetrico.sql` por lotes con metas de volumen por entidad aplicable.
- Incluir cobertura volumetrica de viaje: `ticket_segment`, `seat_assignment`, `baggage`,
  `check_in`, `boarding_pass`, `boarding_validation`, y escenarios de `refund` cuando aplique.
- Salida esperada: seed volumetrico ejecutable de punta a punta sobre base limpia.

### Tramo B. Gate volumetrico de validacion

- Extender `99_validaciones_post_seed.sql` con umbrales de fase volumetrica.
- Incorporar chequeos de cronologia y orfandad para nuevas tablas pobladas en volumen.
- Salida esperada: reporte de validacion sin fallas bloqueantes.

### Tramo C. QA cruzado de narrativa y evidencia

- Alinear `landing`, `canvas`, `reportes` y `seguimiento` al mismo estado real.
- Verificar que no existan afirmaciones de "pendiente" cuando ya hay implementacion parcial.
- Salida esperada: narrativa unica y auditable.

### Tramo D. Pre-release arquitectonico

- Cerrar IE en seguimiento que impacten lectura ejecutiva.
- Congelar paquete tecnico y registrar backlog de refactor posterior.
- Salida esperada: paquete listo para entrega tecnica y explicacion ejecutiva.

## 6. Prioridad de fixes (orden de ejecucion)

1. P0: Cierre del gate volumetrico (datos + validaciones).
2. P1: QA cruzado documental y consistencia de estado.
3. P2: Ajustes de presentacion y refinamiento final para release.

## 7. Definicion de listo para continuar

Se considera lista la siguiente iteracion cuando:

- `01_seed_volumetrico.sql` corre completo sobre base limpia.
- `99_validaciones_post_seed.sql` no reporta fallas bloqueantes en fase volumetrica.
- Documentacion y reportes reflejan exactamente el mismo estado de avance.
