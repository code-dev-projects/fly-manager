# Evidencia de Auditoria de Seguridad Local (2026-03-20)

## Objetivo

Auditar el estado de privilegios, roles, secretos locales y superficie de
exposicion del PostgreSQL de desarrollo despues del hardening inicial S3.3.

## Contexto de ejecucion

- Fecha de ejecucion: 2026-03-20 11:04:59 -05:00
- Contenedor: fly-bd-pg-5435
- Base auditada: flydb
- Role admin actual: fly_admin
- Roles de minimo privilegio esperados: fly_app_rw, fly_app_ro, fly_app_audit

## Resumen observado

| metric | value |
| --- | --- |
| public_tables | 76 |
| hard_fail_controls | 0 |
| risk_controls | 2 |
| superuser_login_roles | 1 |
| local_env_exists | True |

## Roles relevantes

| role_name | superuser | create_role | create_db | can_login |
| --- | --- | --- | --- | --- |
| fly_admin | t | t | t | t |
| fly_app_audit | f | f | f | f |
| fly_app_ro | f | f | f | f |
| fly_app_rw | f | f | f | f |

## Controles de seguridad

| control | observed | expected | status | note |
| --- | --- | --- | --- | --- |
| public_connect_revoked | f | false | OK | PUBLIC no debe conservar CONNECT sobre la base |
| public_schema_create_revoked | f | false | OK | PUBLIC no debe poder crear en schema public |
| public_schema_usage_revoked | f | false | OK | PUBLIC no debe conservar USAGE abierto en schema public |
| least_privilege_roles_present | 3 | 3 | OK | Roles base de runtime, readonly y audit deben existir |
| runtime_rw_grants_complete | 76/76/76/76 | 76/76/76/76 | OK | Runtime debe tener DML completo sobre tablas public |
| readonly_select_grants_complete | 76 | 76 | OK | Readonly debe tener SELECT sobre todas las tablas public |
| audit_select_grants_complete | 76 | 76 | OK | Audit debe tener SELECT sobre todas las tablas public |
| audit_role_has_pg_read_all_stats | t | true | OK | Audit debe poder leer estadisticas globales |
| superuser_login_present | 1 | 0 ideal | RIESGO | Hoy persiste al menos un login superuser |
| repo_weak_password_literal_removed | False | false | OK | No debe permanecer la clave literal legacy en archivos versionados |
| local_env_secret_present | True | true recomendado | OK | Se recomienda definir POSTGRES_PASSWORD en infra/docker/.env |
| compose_password_placeholder_present | True | true | OK | El repo debe sugerir placeholder y no una clave operativa real |
| host_port_published | True | controlado | RIESGO | El puerto queda expuesto al host para desarrollo local |

## Resultado

- Estado general: AUDITORIA SIN FALLAS BLOQUEANTES
- Fallas bloqueantes: 0
- Riesgos controlados: 2
