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
| IE-003 | 2026-03-19 | Seeds masivos | Alta | En seguimiento | Ya existe un bloque raiz implementado en `00_seed_canonico.sql`, pero aun faltan geografia, actores, flujo canonico y seed volumetrico real. | La base tiene catalogos consistentes, pero todavia no valida volumetria ni flujo completo. | Completar `00_seed_canonico.sql` por capas y luego implementar `01_seed_volumetrico.sql`. |
| IE-004 | 2026-03-19 | Orden de carga | Alta | Resuelto | La matriz topologica definitiva de carga por FK ya fue extraida y documentada. | Reduce el riesgo de fallas por secuencia incorrecta al poblar datos. | Usar `docs/validacion/MATRIZ_ORDEN_CARGA_SEEDS.md` como contrato operativo del pipeline. |
| IE-005 | 2026-03-19 | Reglas temporales | Alta | Abierto | Aun no existe una politica formal para fechas y cronologia de datos sinteticos. | Las relaciones reserva-ticket-pago-factura pueden perder plausibilidad operativa. | Definir ventanas temporales, husos y precedencia de eventos antes del seed volumetrico. |
| IE-006 | 2026-03-19 | Infraestructura local | Observacion | Resuelto | El contenedor de PostgreSQL ya fue estandarizado en `localhost:5435` con inicializacion automatica del DDL. | Reduce dispersion operativa y facilita pruebas repetibles. | Mantener esta convencion como punto unico de entrada local. |
| IE-007 | 2026-03-19 | Validacion funcional punta a punta | Bloqueante | Abierto | Aun no existen inserts reales que cubran el flujo `reservation -> sale -> ticket -> payment -> invoice` con datos consistentes. | La base compila, pero todavia no demuestra comportamiento funcional completo. | Implementar primero `00_seed_canonico.sql` y validarlo con caso integral antes del seed volumetrico. |
| IE-008 | 2026-03-19 | Cronograma vs estado real | Media | En seguimiento | El cronograma expresa camino critico y riesgos, pero esa narrativa puede interpretarse como si la fase de datos ya estuviera ejecutada. | Puede generar una lectura demasiado optimista del estado de seeds. | Alinear explicitamente el cronograma y los reportes al estado pendiente de generacion real de datos. |
| IE-009 | 2026-03-19 | Politica de validacion post-seed | Media | Abierto | El control actual de volumen sigue usando un umbral simplificado con excepciones, pero la fase real requerira metas por tabla y por etapa. | Puede generar falsos positivos en tablas que no deben llegar a `1000`, como fabricantes, aerolineas, aeropuertos o permisos. | Evolucionar `99_validaciones_post_seed.sql` hacia una matriz de objetivos minimos por tabla y por fase. |

## Regla de Actualizacion

Cada nuevo hallazgo debe registrar:

- evidencia concreta
- archivo o modulo afectado
- impacto funcional y estructural
- propuesta de correccion o criterio de excepcion
- fecha y estado actualizado
