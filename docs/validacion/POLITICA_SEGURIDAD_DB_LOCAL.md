# Politica de Seguridad DB Local (S3.3)

## 1. Objetivo

Reducir superficie de riesgo en PostgreSQL local mediante privilegios minimos,
higiene de secretos y auditoria verificable de accesos.

## 2. Alcance

- Roles y grants dentro de la base local Docker.
- Manejo de `POSTGRES_PASSWORD` en infraestructura local.
- Evidencia operativa de auditoria de seguridad.

## 3. Artefactos operativos

- `infra/tools/endurecer_seguridad_postgres_local.ps1`
- `infra/tools/auditar_seguridad_postgres_local.ps1`
- `infra/tools/validar_secretos_locales.ps1`
- `infra/tools/provisionar_logins_operativos_locales.ps1`
- `infra/tools/validar_logins_operativos_locales.ps1`
- `infra/tools/validar_menor_privilegio_operativo_local.ps1`
- `docs/validacion/MATRIZ_PRIVILEGIOS_DB_LOCAL.md`

## 4. Principios

1. El owner administrativo no debe ser el usuario operativo cotidiano.
2. Los permisos deben otorgarse a roles de grupo, no directamente a cuentas
   dispersas.
3. `PUBLIC` no debe conservar accesos innecesarios sobre base o schema.
4. Los secretos locales deben residir en `infra/docker/.env` no versionado.
5. El uso cotidiano local debe apoyarse en logins operativos con menor privilegio
   y no en `fly_admin`.
6. Diagnostico, observabilidad y baseline no deben volver a degradarse hacia
   `fly_admin` como default silencioso.

## 5. Flujo recomendado

1. Aplicar hardening:
   - `.\infra\tools\endurecer_seguridad_postgres_local.ps1`
2. Validar secreto local:
   - `.\infra\tools\validar_secretos_locales.ps1`
3. Provisionar logins operativos:
   - `.\infra\tools\provisionar_logins_operativos_locales.ps1`
4. Validar logins operativos:
   - `.\infra\tools\validar_logins_operativos_locales.ps1`
5. Validar menor privilegio operativo:
   - `.\infra\tools\validar_menor_privilegio_operativo_local.ps1`
6. Ejecutar auditoria:
   - `.\infra\tools\auditar_seguridad_postgres_local.ps1`
7. Revisar evidencia publicada en `docs/validacion/`.
8. Para reconstruccion completa, `.\infra\docker\recrear_instalacion_limpia.ps1`
   debe dejar la base recreada con hardening y auditoria ya ejecutados.

## 6. Criterio de salida inicial S3.3

- Roles de minimo privilegio creados.
- Logins operativos locales creados y conectables.
- `PUBLIC` sin `CONNECT` sobre la base local objetivo.
- `PUBLIC` sin `USAGE/CREATE` sobre schema `public`.
- Diagnostico/observabilidad/baseline operan por defecto con logins no administrativos.
- Evidencia de auditoria sin fallas bloqueantes.
- Riesgos residuales documentados.
