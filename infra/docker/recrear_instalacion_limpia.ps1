$ErrorActionPreference = "Stop"

Write-Host "Recreando instalacion limpia de FLY..."
docker compose down -v
docker compose up -d

Write-Host "Esperando que PostgreSQL quede healthy..."
Start-Sleep -Seconds 10

docker ps --filter name=fly-bd-pg-5435 --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"

Write-Host "Conteo de catalogos base cargados automaticamente:"
docker exec fly-bd-pg-5435 psql -U fly_admin -d flydb -P pager=off -F "," -At -c "select 'currency', count(*) from public.currency union all select 'security_role', count(*) from public.security_role union all select 'role_permission', count(*) from public.role_permission order by 1;"
