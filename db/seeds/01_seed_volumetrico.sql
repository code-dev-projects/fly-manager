\set ON_ERROR_STOP on
\echo '01_seed_volumetrico.sql - expansion masiva controlada sobre seed canonico'
SET client_min_messages TO warning;

BEGIN;

-- ============================================================
-- POLITICA: Ver docs/validacion/POLITICA_CRONOLOGIA_DATOS_SINTETICOS.md
-- Vuelos futuros : 2026-04-01 a 2026-06-30  (status SCHEDULED)
-- Reservas futuras: booked_at entre 2026-01-10 y 2026-03-18
-- Personas       : 300 adultos colombianos (UUID 90000000-...)
-- Clientes       : 250 de esas personas    (UUID 93000000-...)
-- Reservas       : 20 CONFIRMED             (UUID A7000000-...)
-- ============================================================

-- ============================================================
-- PARTE 1: VUELOS FUTUROS Q2 2026
-- FY120  BOG → MDE  diario  (HK-5500)   91 vuelos
-- FY220  BOG → MIA  miercoles (HK-7870) 13 vuelos
-- FY712  MIA → MAD  miercoles (HK-7870) 13 vuelos  (cont. FY220)
-- ============================================================

INSERT INTO public.flight (
  airline_id, aircraft_id, flight_status_id, flight_number, service_date
)
SELECT
  al.airline_id,
  a.aircraft_id,
  fs.flight_status_id,
  'FY120',
  d.service_date::date
FROM generate_series(
  '2026-04-01'::date,
  '2026-06-30'::date,
  '1 day'::interval
) AS d(service_date)
JOIN public.airline al        ON al.airline_code         = 'FLY'
JOIN public.aircraft a        ON a.registration_number   = 'HK-5500'
JOIN public.flight_status fs  ON fs.status_code          = 'SCHEDULED'
ON CONFLICT (airline_id, flight_number, service_date) DO NOTHING;

-- Miercoles Q2: 01-apr, 08-apr, 15-apr, 22-apr, 29-apr,
--               06-may, 13-may, 20-may, 27-may,
--               03-jun, 10-jun, 17-jun, 24-jun
INSERT INTO public.flight (
  airline_id, aircraft_id, flight_status_id, flight_number, service_date
)
SELECT
  al.airline_id,
  a.aircraft_id,
  fs.flight_status_id,
  seed.fn,
  seed.service_date
FROM (
  SELECT
    fn,
    d.service_date::date AS service_date
  FROM generate_series(
    '2026-04-01'::date,
    '2026-06-30'::date,
    '7 day'::interval
  ) AS d(service_date)
  CROSS JOIN (VALUES ('FY220'), ('FY712')) AS t(fn)
  WHERE EXTRACT(DOW FROM d.service_date) = 3   -- miercoles
) AS seed
JOIN public.airline al        ON al.airline_code         = 'FLY'
JOIN public.aircraft a        ON a.registration_number   = 'HK-7870'
JOIN public.flight_status fs  ON fs.status_code          = 'SCHEDULED'
ON CONFLICT (airline_id, flight_number, service_date) DO NOTHING;

-- ============================================================
-- SEGMENTOS DE VUELO
-- FY120: BOG 09:00-05 → MDE 10:05-05  (65 min)
-- FY220: BOG 08:00-05 → MIA 12:15-04  (4h15 con ajuste DST)
-- FY712: MIA 16:00-04 → MAD 05:45+01  (conexion con FY220)
-- ============================================================

INSERT INTO public.flight_segment (
  flight_id, origin_airport_id, destination_airport_id,
  segment_number,
  scheduled_departure_at,
  scheduled_arrival_at
)
SELECT
  f.flight_id,
  ao.airport_id,
  ad.airport_id,
  1,
  (f.service_date::timestamp + INTERVAL '9 hours')  AT TIME ZONE 'America/Bogota',
  (f.service_date::timestamp + INTERVAL '10 hours 5 minutes') AT TIME ZONE 'America/Bogota'
FROM public.flight f
JOIN public.airline al ON al.airline_id = f.airline_id AND al.airline_code = 'FLY'
JOIN public.airport ao ON ao.iata_code = 'BOG'
JOIN public.airport ad ON ad.iata_code = 'MDE'
WHERE f.flight_number = 'FY120'
  AND f.service_date BETWEEN '2026-04-01' AND '2026-06-30'
ON CONFLICT (flight_id, segment_number) DO NOTHING;

INSERT INTO public.flight_segment (
  flight_id, origin_airport_id, destination_airport_id,
  segment_number,
  scheduled_departure_at,
  scheduled_arrival_at
)
SELECT
  f.flight_id,
  ao.airport_id,
  ad.airport_id,
  1,
  (f.service_date::timestamp + INTERVAL '8 hours')  AT TIME ZONE 'America/Bogota',
  (f.service_date::timestamp + INTERVAL '17 hours 15 minutes') AT TIME ZONE 'America/Bogota'
FROM public.flight f
JOIN public.airline al ON al.airline_id = f.airline_id AND al.airline_code = 'FLY'
JOIN public.airport ao ON ao.iata_code = 'BOG'
JOIN public.airport ad ON ad.iata_code = 'MIA'
WHERE f.flight_number = 'FY220'
  AND f.service_date BETWEEN '2026-04-01' AND '2026-06-30'
ON CONFLICT (flight_id, segment_number) DO NOTHING;

INSERT INTO public.flight_segment (
  flight_id, origin_airport_id, destination_airport_id,
  segment_number,
  scheduled_departure_at,
  scheduled_arrival_at
)
SELECT
  f.flight_id,
  ao.airport_id,
  ad.airport_id,
  1,
  -- sale MIA 16:00 EDT (UTC-4)
  (f.service_date::timestamp + INTERVAL '20 hours') AT TIME ZONE 'UTC',
  -- llega MAD 05:45 CET (UTC+1) del dia siguiente
  (f.service_date::timestamp + INTERVAL '1 day 4 hours 45 minutes') AT TIME ZONE 'UTC'
FROM public.flight f
JOIN public.airline al ON al.airline_id = f.airline_id AND al.airline_code = 'FLY'
JOIN public.airport ao ON ao.iata_code = 'MIA'
JOIN public.airport ad ON ad.iata_code = 'MAD'
WHERE f.flight_number = 'FY712'
  AND f.service_date BETWEEN '2026-04-01' AND '2026-06-30'
ON CONFLICT (flight_id, segment_number) DO NOTHING;

-- ============================================================
-- PARTE 2: PERSONAS EN MASA (300 adultos colombianos)
-- UUID pattern: 90000000-0000-0000-0000-XXXXXXXXXXXX
-- Nombres ciclicos para variedad controlada
-- ============================================================

INSERT INTO public.person (
  person_id, person_type_id, nationality_country_id,
  first_name, last_name, birth_date, gender_code
)
SELECT
  ('90000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  pt.person_type_id,
  c.country_id,
  (ARRAY[
    'Ana','Carlos','Maria','Jorge','Laura',
    'David','Sofia','Andres','Valentina','Felipe',
    'Camila','Sebastian','Isabella','Daniel','Natalia',
    'Ricardo','Alejandra','Juan','Paula','Luis'
  ])[((g.i - 1) % 20) + 1],
  (ARRAY[
    'Garcia','Mendoza','Torres','Ramirez','Lopez',
    'Hernandez','Martinez','Gonzalez','Rodriguez','Perez',
    'Sanchez','Flores','Morales','Jimenez','Castro',
    'Ortiz','Ruiz','Reyes','Cruz','Vargas'
  ])[((g.i - 1) % 20) + 1],
  -- distribucion de fechas de nacimiento 1960-1999
  DATE '1960-01-01' + ((g.i * 47) % 14600) * INTERVAL '1 day',
  CASE WHEN (g.i % 2) = 0 THEN 'M' ELSE 'F' END
FROM generate_series(1, 300) AS g(i)
JOIN public.person_type pt ON pt.type_code = 'ADULT'
JOIN public.country c      ON c.iso_alpha2  = 'CO'
ON CONFLICT (person_id) DO NOTHING;

-- ============================================================
-- DOCUMENTOS: NID por cada persona volumetrica
-- Numero unico: 'VCC' + lpad(i,7,'0')
-- ============================================================

INSERT INTO public.person_document (
  person_document_id, person_id, document_type_id,
  issuing_country_id, document_number
)
SELECT
  ('91000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('90000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  dt.document_type_id,
  c.country_id,
  'VCC' || lpad(g.i::text, 7, '0')
FROM generate_series(1, 300) AS g(i)
JOIN public.document_type dt ON dt.type_code  = 'NID'
JOIN public.country c        ON c.iso_alpha2  = 'CO'
ON CONFLICT (person_document_id) DO NOTHING;

-- ============================================================
-- CONTACTOS: un email por persona volumetrica
-- ============================================================

INSERT INTO public.person_contact (
  person_contact_id, person_id, contact_type_id,
  contact_value, is_primary
)
SELECT
  ('92000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('90000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ct.contact_type_id,
  'vol.' || lpad(g.i::text, 6, '0') || '@flymail.co',
  true
FROM generate_series(1, 300) AS g(i)
JOIN public.contact_type ct ON ct.type_code = 'EMAIL'
ON CONFLICT (person_contact_id) DO NOTHING;

-- ============================================================
-- CLIENTES: 250 de las 300 personas volumetricas
-- Categoria distribuida: REG(60%), SILV(25%), GOLD(10%), CORP(5%)
-- UUID: 93000000-0000-0000-0000-XXXXXXXXXXXX
-- ============================================================

INSERT INTO public.customer (
  customer_id, airline_id, person_id,
  customer_category_id, customer_since
)
SELECT
  ('93000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  al.airline_id,
  ('90000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  cc.customer_category_id,
  DATE '2024-01-01' + ((g.i * 3) % 450) * INTERVAL '1 day'
FROM generate_series(1, 250) AS g(i)
JOIN public.airline al ON al.airline_code = 'FLY'
JOIN public.customer_category cc ON cc.category_code = (
  CASE
    WHEN (g.i % 20) = 0 THEN 'CORP'
    WHEN (g.i % 10) IN (1,2) THEN 'GOLD'
    WHEN (g.i % 4)  IN (1,2) THEN 'SILV'
    ELSE 'REG'
  END
)
ON CONFLICT (airline_id, person_id) DO NOTHING;

-- ============================================================
-- LOYALTY ACCOUNTS: una por cliente volumetrico
-- UUID: 94000000-0000-0000-0000-XXXXXXXXXXXX
-- Numero: FLY-VOL-XXXXXXXX
-- ============================================================

INSERT INTO public.loyalty_account (
  loyalty_account_id, customer_id, loyalty_program_id,
  account_number, opened_at
)
SELECT
  ('94000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('93000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  lp.loyalty_program_id,
  'FLY-VOL-' || lpad(g.i::text, 8, '0'),
  DATE '2024-01-01' + ((g.i * 3) % 450) * INTERVAL '1 day'
FROM generate_series(1, 250) AS g(i)
JOIN public.loyalty_program lp ON lp.program_code = 'FLY_MILES'
ON CONFLICT (account_number) DO NOTHING;

-- ============================================================
-- LOYALTY ACCOUNT TIERS: tier activo por cuenta
-- Distribucion: BRONZE(60%), SILVER(30%), GOLD(10%)
-- UUID: 95000000-0000-0000-0000-XXXXXXXXXXXX
-- ============================================================

INSERT INTO public.loyalty_account_tier (
  loyalty_account_tier_id, loyalty_account_id, loyalty_tier_id,
  assigned_at, expires_at
)
SELECT
  ('95000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('94000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  lt.loyalty_tier_id,
  DATE '2024-06-01' + ((g.i * 7) % 200) * INTERVAL '1 day',
  TIMESTAMPTZ '2026-12-31 23:59:59-05'
FROM generate_series(1, 250) AS g(i)
JOIN public.loyalty_tier lt ON lt.tier_code = (
  CASE
    WHEN (g.i % 10) = 0 THEN 'GOLD'
    WHEN (g.i % 10) IN (1,2,3) THEN 'SILVER'
    ELSE 'BRONZE'
  END
)
  AND lt.loyalty_program_id = (
    SELECT lp.loyalty_program_id FROM public.loyalty_program lp
    WHERE lp.program_code = 'FLY_MILES'
  )
ON CONFLICT (loyalty_account_id, assigned_at) DO NOTHING;

-- ============================================================
-- MILLAS HISTORICAS: saldo inicial por cliente volumetrico
-- EARN simbolico para reflejar historial de viajes pasados
-- UUID: 96000000-0000-0000-0000-XXXXXXXXXXXX
-- ============================================================

INSERT INTO public.miles_transaction (
  miles_transaction_id, loyalty_account_id,
  transaction_type, miles_delta, occurred_at, reference_code, notes
)
SELECT
  ('96000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('94000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  'EARN',
  -- saldo inicial entre 500 y 75000 segun patron
  500 + ((g.i * 313) % 74500),
  TIMESTAMPTZ '2025-01-01 00:00:00-05' + ((g.i * 5) % 365) * INTERVAL '1 day',
  'HIST-SALDO-INICIAL-' || lpad(g.i::text, 6, '0'),
  'Saldo historico inicial cargado en seed volumetrico'
FROM generate_series(1, 250) AS g(i)
ON CONFLICT (miles_transaction_id) DO NOTHING;

-- ============================================================
-- PARTE 3: 20 RESERVAS FUTURAS CONFIRMADAS
-- Vuelo FY120 BOG→MDE en fechas distribuidas Q2 2026
-- booked_at: 2026-01-10 a 2026-03-08  (IE-005: antes de fecha base 2026-03-19)
-- Clientes: personas volumetricas 1..20
-- Fare: FLY-BOGMDE-YB-2026  (COP 310,000)
-- Total con tasas: COP 359,600
-- ============================================================

INSERT INTO public.reservation (
  reservation_id, booked_by_customer_id, reservation_status_id,
  sale_channel_id, reservation_code, booked_at, expires_at, notes
)
SELECT
  ('A7000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('93000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  rs.reservation_status_id,
  sc.sale_channel_id,
  'RES-VOL-' || lpad(g.i::text, 6, '0'),
  -- booked_at entre 2026-01-10 y 2026-03-08 (IE-005: antes de fecha base 2026-03-19)
  DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day',
  NULL,
  'Reserva volumetrica FY120 BOG-MDE pasajero ' || g.i
FROM generate_series(1, 20) AS g(i)
JOIN public.reservation_status rs ON rs.status_code  = 'CONFIRMED'
JOIN public.sale_channel sc        ON sc.channel_code = (
  CASE WHEN (g.i % 3) = 0 THEN 'MOBILE_APP'
       WHEN (g.i % 3) = 1 THEN 'WEB'
       ELSE 'CALL_CENTER'
  END
)
ON CONFLICT (reservation_code) DO NOTHING;

-- ============================================================
-- PASAJEROS DE LAS 20 RESERVAS VOLUMETRICAS
-- ============================================================

INSERT INTO public.reservation_passenger (
  reservation_passenger_id, reservation_id, person_id,
  passenger_sequence_no, passenger_type
)
SELECT
  ('A8000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A7000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('90000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  1,
  'ADULT'
FROM generate_series(1, 20) AS g(i)
ON CONFLICT (reservation_id, person_id) DO NOTHING;

-- ============================================================
-- VENTAS DE LAS 20 RESERVAS VOLUMETRICAS
-- ============================================================

INSERT INTO public.sale (
  sale_id, reservation_id, currency_id,
  sale_code, sold_at, external_reference
)
SELECT
  ('A9000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A7000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  cu.currency_id,
  'SAL-VOL-' || lpad(g.i::text, 6, '0'),
  -- sold 5 min despues de la reserva
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '5 minutes',
  'EXT-VOL-' || lpad(g.i::text, 6, '0')
FROM generate_series(1, 20) AS g(i)
JOIN public.currency cu ON cu.iso_currency_code = 'COP'
ON CONFLICT (sale_code) DO NOTHING;

-- ============================================================
-- TIQUETES (status ISSUED — vuelo futuro)
-- ============================================================

INSERT INTO public.ticket (
  ticket_id, sale_id, reservation_passenger_id,
  fare_id, ticket_status_id, ticket_number, issued_at
)
SELECT
  ('AA000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A9000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A8000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  f.fare_id,
  ts.ticket_status_id,
  'TKT-VOL-' || lpad(g.i::text, 6, '0'),
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '7 minutes'
FROM generate_series(1, 20) AS g(i)
JOIN public.fare f              ON f.fare_code    = 'FLY-BOGMDE-YB-2026'
JOIN public.ticket_status ts    ON ts.status_code = 'ISSUED'
ON CONFLICT (ticket_number) DO NOTHING;

-- ============================================================
-- SEGMENTOS DE TIQUETE: cada tiquete a FY120 en su fecha
-- ============================================================

INSERT INTO public.ticket_segment (
  ticket_segment_id, ticket_id, flight_segment_id,
  segment_sequence_no, fare_basis_code
)
SELECT
  ('AB000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('AA000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  fs.flight_segment_id,
  1,
  'YB'
FROM generate_series(1, 20) AS g(i)
-- vuelo FY120 en la fecha correspondiente
JOIN public.flight f  ON f.flight_number = 'FY120'
                     AND f.service_date   = (DATE '2026-04-06' + (g.i - 1) * 3)
JOIN public.airline al ON al.airline_id   = f.airline_id AND al.airline_code = 'FLY'
JOIN public.flight_segment fs ON fs.flight_id = f.flight_id AND fs.segment_number = 1
ON CONFLICT (ticket_segment_id) DO NOTHING;

-- ============================================================
-- PAGOS (AUTHORIZED — pendiente captura en vuelo futuro)
-- ============================================================

INSERT INTO public.payment (
  payment_id, sale_id, payment_status_id, payment_method_id,
  currency_id, payment_reference, amount, authorized_at
)
SELECT
  ('AC000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A9000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ps.payment_status_id,
  pm.payment_method_id,
  cu.currency_id,
  'PAY-VOL-' || lpad(g.i::text, 6, '0'),
  359600.00,
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '6 minutes'
FROM generate_series(1, 20) AS g(i)
JOIN public.payment_status ps ON ps.status_code = 'AUTHORIZED'
JOIN public.payment_method pm ON pm.method_code = (
  CASE WHEN (g.i % 3) = 0 THEN 'DEBIT_CARD'
       WHEN (g.i % 3) = 1 THEN 'CREDIT_CARD'
       ELSE 'WALLET'
  END
)
JOIN public.currency cu ON cu.iso_currency_code = 'COP'
ON CONFLICT (payment_reference) DO NOTHING;

-- ============================================================
-- TRANSACCIONES DE PAGO (AUTH para vuelos futuros)
-- ============================================================

INSERT INTO public.payment_transaction (
  payment_transaction_id, payment_id,
  transaction_reference, transaction_type,
  transaction_amount, processed_at, provider_message
)
SELECT
  ('AD000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('AC000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  'TXN-VOL-AUTH-' || lpad(g.i::text, 6, '0'),
  'AUTH',
  359600.00,
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '6 minutes 5 seconds',
  'Autorizacion aprobada para vuelo futuro FY120.'
FROM generate_series(1, 20) AS g(i)
ON CONFLICT (transaction_reference) DO NOTHING;

-- ============================================================
-- FACTURAS
-- ============================================================

INSERT INTO public.invoice (
  invoice_id, sale_id, invoice_status_id, currency_id,
  invoice_number, issued_at, due_at, notes
)
SELECT
  ('AE000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ('A9000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  ist.invoice_status_id,
  cu.currency_id,
  'INV-VOL-2026-' || lpad(g.i::text, 4, '0'),
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '8 minutes',
  (DATE '2026-01-10' + (g.i - 1) * 3 * INTERVAL '1 day')
    + INTERVAL '8 minutes',
  'Factura reserva volumetrica FY120 BOG-MDE'
FROM generate_series(1, 20) AS g(i)
JOIN public.invoice_status ist ON ist.status_code      = 'ISSUED'
JOIN public.currency cu        ON cu.iso_currency_code = 'COP'
ON CONFLICT (invoice_number) DO NOTHING;

-- ============================================================
-- LINEAS DE FACTURA (3 lineas por factura: base + 2 tasas)
-- ============================================================

-- Linea 1: tarifa base
INSERT INTO public.invoice_line (
  invoice_line_id, invoice_id, tax_id,
  line_number, line_description, quantity, unit_price
)
SELECT
  ('AF000000-0000-0000-0000-' || lpad(((g.i - 1) * 3 + 1)::text, 12, '0'))::uuid,
  ('AE000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  NULL,
  1,
  'Tarifa base Economy YB BOG-MDE',
  1.00,
  310000.00
FROM generate_series(1, 20) AS g(i)
ON CONFLICT (invoice_id, line_number) DO NOTHING;

-- Linea 2: tasa aeroportuaria 12 %
INSERT INTO public.invoice_line (
  invoice_line_id, invoice_id, tax_id,
  line_number, line_description, quantity, unit_price
)
SELECT
  ('AF000000-0000-0000-0000-' || lpad(((g.i - 1) * 3 + 2)::text, 12, '0'))::uuid,
  ('AE000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  tx.tax_id,
  2,
  'Tasa aeroportuaria 12 %',
  1.00,
  37200.00
FROM generate_series(1, 20) AS g(i)
JOIN public.tax tx ON tx.tax_code = 'AIRPORT_FEE'
ON CONFLICT (invoice_id, line_number) DO NOTHING;

-- Linea 3: tasa de seguridad 4 %
INSERT INTO public.invoice_line (
  invoice_line_id, invoice_id, tax_id,
  line_number, line_description, quantity, unit_price
)
SELECT
  ('AF000000-0000-0000-0000-' || lpad(((g.i - 1) * 3 + 3)::text, 12, '0'))::uuid,
  ('AE000000-0000-0000-0000-' || lpad(g.i::text, 12, '0'))::uuid,
  tx.tax_id,
  3,
  'Tasa de seguridad 4 %',
  1.00,
  12400.00
FROM generate_series(1, 20) AS g(i)
JOIN public.tax tx ON tx.tax_code = 'SECURITY_FEE'
ON CONFLICT (invoice_id, line_number) DO NOTHING;

COMMIT;
