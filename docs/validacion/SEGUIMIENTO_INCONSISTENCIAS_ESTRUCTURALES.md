# Seguimiento Estricto de Inconsistencias Estructurales

## Objetivo

Registrar de forma continua los posibles desalineamientos arquitectonicos y estructurales del sistema FLY para preparar una futura fase de refactorizacion con evidencia.

## Convenciones

- `Bloqueante`: impide o invalida la siguiente fase
- `Alta`: no bloquea hoy, pero compromete consistencia o realismo
- `Media`: genera deuda tecnica o ambiguedad documental
- `Observacion`: mejora recomendada sin impacto inmediato

Estados:

- `Abierto`
- `En seguimiento`
- `Resuelto`
- `Excepcion controlada`

## Hallazgos Iniciales

| ID | Fecha | Objeto | Severidad | Estado | Hallazgo | Impacto | Recomendacion |
|----|-------|--------|-----------|--------|----------|---------|---------------|
| IE-001 | 2026-03-19 | Politica de seeds | Alta | En seguimiento | El requerimiento de `1000` filas por tabla entra en conflicto con catalogos cerrados del dominio. | Puede degradar realismo y contaminar la base canonica que servira para refactor. | Mantener `seed canonico` realista y tratar catalogos cerrados como excepcion controlada. |
| IE-002 | 2026-03-19 | Documentacion historica | Media | Abierto | Existen documentos heredados que aun referencian rutas previas a la reorganizacion del repositorio. | Riesgo de confusion al auditar evidencias y fuentes. | Alinear progresivamente referencias internas o marcar los artefactos como historicos. |
| IE-003 | 2026-03-19 | Seeds masivos | Alta | En seguimiento | El seed canonico cubre el flujo E2E completo. El seed volumetrico ya agrega vuelos futuros Q2 y una capa inicial de personas/clientes/reservas/pagos/facturas, pero aun no cierra metas de volumen objetivo ni cobertura completa del flujo de viaje volumetrico. | Hay avance real sobre la base canonica, pero el gate volumetrico sigue parcial. | Escalar `01_seed_volumetrico.sql` por lotes y extender validaciones para metas volumetricas por entidad aplicable. |
| IE-004 | 2026-03-19 | Orden de carga | Alta | Resuelto | La matriz topologica definitiva de carga por FK ya fue extraida y documentada. | Reduce el riesgo de fallas por secuencia incorrecta al poblar datos. | Usar `docs/validacion/MATRIZ_ORDEN_CARGA_SEEDS.md` como contrato operativo del pipeline. |
| IE-005 | 2026-03-19 | Reglas temporales | Alta | Resuelto | Politica de cronologia definida y documentada en `docs/validacion/POLITICA_CRONOLOGIA_DATOS_SINTETICOS.md`. Cubre: epoch tarifario, ventanas de vuelos historicos, ciclo de vida de reserva, apertura de cuentas de lealtad, husos horarios por aeropuerto (incluyendo EDT de Miami en marzo 2026) y restricciones de consistencia cronologica. | Seed canonico aplica la politica en todos sus timestamps. | Usar como contrato obligatorio en el seed volumetrico. |
| IE-006 | 2026-03-19 | Infraestructura local | Observacion | Resuelto | El contenedor de PostgreSQL ya fue estandarizado en `localhost:5435` con inicializacion automatica del DDL. | Reduce dispersion operativa y facilita pruebas repetibles. | Mantener esta convencion como punto unico de entrada local. |
| IE-007 | 2026-03-19 | Validacion funcional punta a punta | Bloqueante | Resuelto | El seed canonico implementa 3 flujos comerciales completos: (1) Ana Garcia BOG-MIA-MAD Business con conexion, (2) Carlos Mendoza BOG-MDE Economy, (3) Laura Torres BOG-MIA Economy. Cada flujo cubre: person → customer → loyalty → reservation → sale → ticket → ticket_segment → seat_assignment → baggage → check_in → boarding_pass → boarding_validation → payment → payment_transaction → invoice → invoice_line → miles_transaction. Todos los timestamps son consistentes con la politica IE-005. | La base ahora demuestra comportamiento funcional integral end-to-end. | Ejecutar `99_validaciones_post_seed.sql` para confirmar conteos y consistencia. |
| IE-008 | 2026-03-19 | Cronograma vs estado real | Media | En seguimiento | El cronograma expresa camino critico y riesgos, pero la narrativa puede ocultar que el seed volumetrico esta en ejecucion parcial y no cerrado. | Puede generar una lectura optimista del avance y de los gates realmente cerrados. | Alinear explicitamente cronograma y reportes al estado real: volumetrico implementado en fase inicial, pendiente de expansion y QA final. |
| IE-009 | 2026-03-19 | Politica de validacion post-seed | Media | Resuelto | `99_validaciones_post_seed.sql` reescrito con 6 fases: (1) conteo general, (2) gate canonico con matriz de minimos por tabla, (3) tablas sin datos, (4) flujo critico E2E con expected_min por entidad, (5) spot checks de huerfanos referenciales, (6) consistencia cronologica. Elimina el umbral generico de 1000 filas. | El gate canonico ahora es preciso, auditable y no genera falsos positivos. | Extender la matriz de minimos al seed volumetrico cuando corresponda. |

## Regla de Actualizacion

Cada nuevo hallazgo debe registrar:

- evidencia concreta
- archivo o modulo afectado
- impacto funcional y estructural
- propuesta de correccion o criterio de excepcion
- fecha y estado actualizado
