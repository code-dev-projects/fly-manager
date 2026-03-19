$ErrorActionPreference = "Stop"

# ============================================================
# recrear_instalacion_limpia.ps1
# Destruye el volumen, recrea el contenedor y ejecuta todos
# los scripts de inicializacion automaticamente.
# Orden: 01_DDL → 02_seed_canonico → 03_seed_volumetrico
#        → 04_validaciones_post_seed
# ============================================================

Write-Host ""
Write-Host "======================================================"
Write-Host "  FLY Manager - Recreacion de instalacion limpia"
Write-Host "======================================================"
Write-Host ""

# Paso 1: Destruir contenedor y volumen anterior
Write-Host "[1/5] Deteniendo y eliminando contenedor y volumen..."
docker compose down -v
Write-Host "      Contenedor y volumen eliminados."

# Paso 2: Levantar el contenedor (esto dispara initdb automaticamente)
Write-Host ""
Write-Host "[2/5] Levantando contenedor PostgreSQL 16..."
docker compose up -d
Write-Host "      Contenedor iniciado. Esperando que este healthy..."

# Paso 3: Esperar healthcheck real (hasta 120 segundos)
$maxWait = 120
$waited  = 0
$healthy = $false

while ($waited -lt $maxWait) {
    Start-Sleep -Seconds 5
    $waited += 5
    $status = docker inspect --format "{{.State.Health.Status}}" fly-bd-pg-5435 2>$null
    Write-Host "      $waited seg - estado: $status"
    if ($status -eq "healthy") {
        $healthy = $true
        break
    }
}

if (-not $healthy) {
    Write-Host ""
    Write-Host "[ERROR] El contenedor no alcanzo estado 'healthy' en $maxWait segundos."
    Write-Host "        Revisa los logs con: docker logs fly-bd-pg-5435"
    exit 1
}

Write-Host "      Contenedor healthy."

# Paso 4: Verificar que initdb completo (los 4 scripts corrieron)
Write-Host ""
Write-Host "[3/5] Verificando integridad del seed canonico..."
$query = @"
SELECT
  (SELECT count(*) FROM public.country)              AS paises,
  (SELECT count(*) FROM public.airline)              AS aerolineas,
  (SELECT count(*) FROM public.airport)              AS aeropuertos,
  (SELECT count(*) FROM public.aircraft)             AS aeronaves,
  (SELECT count(*) FROM public.flight)               AS vuelos,
  (SELECT count(*) FROM public.person)               AS personas,
  (SELECT count(*) FROM public.customer)             AS clientes,
  (SELECT count(*) FROM public.reservation)          AS reservas,
  (SELECT count(*) FROM public.ticket)               AS tiquetes,
  (SELECT count(*) FROM public.payment)              AS pagos,
  (SELECT count(*) FROM public.invoice)              AS facturas,
  (SELECT count(*) FROM public.miles_transaction)    AS millas;
"@

docker exec fly-bd-pg-5435 psql `
  -U fly_admin -d flydb `
  -P pager=off `
  -c $query

# Paso 5: Verificar seed volumetrico
Write-Host ""
Write-Host "[4/5] Verificando seed volumetrico..."
$queryVol = @"
SELECT
  (SELECT count(*) FROM public.flight  WHERE flight_number IN ('FY120','FY220','FY712'))
    AS vuelos_q2_2026,
  (SELECT count(*) FROM public.person  WHERE person_id::text LIKE '90000000%')
    AS personas_vol,
  (SELECT count(*) FROM public.customer WHERE customer_id::text LIKE '93000000%')
    AS clientes_vol,
  (SELECT count(*) FROM public.reservation WHERE reservation_code LIKE 'RES-VOL%')
    AS reservas_vol,
  (SELECT count(*) FROM public.invoice  WHERE invoice_number LIKE 'INV-VOL%')
    AS facturas_vol;
"@

docker exec fly-bd-pg-5435 psql `
  -U fly_admin -d flydb `
  -P pager=off `
  -c $queryVol

# Paso 6: Estado final del contenedor
Write-Host ""
Write-Host "[5/5] Estado del contenedor:"
docker ps --filter name=fly-bd-pg-5435 --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"

Write-Host ""
Write-Host "======================================================"
Write-Host "  Instalacion completada."
Write-Host "  Conexion: psql -h localhost -p 5435 -U fly_admin -d flydb"
Write-Host "======================================================"
