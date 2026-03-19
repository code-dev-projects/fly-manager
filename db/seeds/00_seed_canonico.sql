\set ON_ERROR_STOP on
\echo '00_seed_canonico.sql - catalogos raiz y referencia controlada'

BEGIN;

SET client_min_messages TO warning;

INSERT INTO public.aircraft_manufacturer (manufacturer_name)
VALUES
  ('Airbus'),
  ('Antonov'),
  ('ATR'),
  ('Beechcraft'),
  ('Boeing'),
  ('Bombardier'),
  ('COMAC'),
  ('De Havilland Canada'),
  ('Embraer'),
  ('Gulfstream'),
  ('Pilatus'),
  ('Sukhoi')
ON CONFLICT (manufacturer_name) DO NOTHING;

INSERT INTO public.benefit_type (benefit_code, benefit_name, benefit_description)
VALUES
  ('EXTRA_BAG', 'Equipaje adicional', 'Permite transportar equipaje por encima del franquiciado.'),
  ('FAST_TRACK', 'Fast track', 'Permite acceso agilizado a filtros de seguridad cuando aplica.'),
  ('LOUNGE', 'Acceso a lounge', 'Habilita acceso a salas VIP propias o de terceros.'),
  ('PRIORITY', 'Abordaje prioritario', 'Permite abordar antes del grupo general.'),
  ('SEAT_PLUS', 'Mejora de asiento', 'Permite seleccionar asiento preferente o con mayor espacio.'),
  ('WAIVER', 'Flexibilidad de cambio', 'Reduce o elimina penalidad de cambio.')
ON CONFLICT (benefit_code) DO UPDATE
SET benefit_name = EXCLUDED.benefit_name,
    benefit_description = EXCLUDED.benefit_description,
    updated_at = now();

INSERT INTO public.boarding_group (group_code, group_name, sequence_no)
VALUES
  ('PRIORITY', 'Prioritario', 1),
  ('A', 'Grupo A', 2),
  ('B', 'Grupo B', 3),
  ('C', 'Grupo C', 4),
  ('D', 'Grupo D', 5)
ON CONFLICT (group_code) DO UPDATE
SET group_name = EXCLUDED.group_name,
    sequence_no = EXCLUDED.sequence_no,
    updated_at = now();

INSERT INTO public.cabin_class (class_code, class_name)
VALUES
  ('F', 'First'),
  ('J', 'Business'),
  ('W', 'Premium Economy'),
  ('Y', 'Economy')
ON CONFLICT (class_code) DO UPDATE
SET class_name = EXCLUDED.class_name,
    updated_at = now();

INSERT INTO public.check_in_status (status_code, status_name)
VALUES
  ('CANCELLED', 'Cancelado'),
  ('COMPLETED', 'Completado'),
  ('OPEN', 'Abierto'),
  ('PENDING', 'Pendiente'),
  ('NO_SHOW', 'No presentado')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.contact_type (type_code, type_name)
VALUES
  ('EMAIL', 'Correo electronico'),
  ('EMERGENCY', 'Contacto de emergencia'),
  ('HOME_PHONE', 'Telefono residencial'),
  ('MOBILE', 'Telefono movil'),
  ('WHATSAPP', 'WhatsApp'),
  ('WORK_PHONE', 'Telefono laboral')
ON CONFLICT (type_code) DO UPDATE
SET type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO public.continent (continent_code, continent_name)
VALUES
  ('AF', 'Africa'),
  ('AN', 'Antarctica'),
  ('AS', 'Asia'),
  ('EU', 'Europe'),
  ('NA', 'North America'),
  ('OC', 'Oceania'),
  ('SA', 'South America')
ON CONFLICT (continent_code) DO UPDATE
SET continent_name = EXCLUDED.continent_name,
    updated_at = now();

INSERT INTO public.currency (iso_currency_code, currency_name, currency_symbol, minor_units)
VALUES
  ('BRL', 'Brazilian Real', 'R$', 2),
  ('COP', 'Colombian Peso', '$', 2),
  ('EUR', 'Euro', 'EUR', 2),
  ('GBP', 'Pound Sterling', 'GBP', 2),
  ('JPY', 'Japanese Yen', 'JPY', 0),
  ('MXN', 'Mexican Peso', '$', 2),
  ('USD', 'US Dollar', '$', 2)
ON CONFLICT (iso_currency_code) DO UPDATE
SET currency_name = EXCLUDED.currency_name,
    currency_symbol = EXCLUDED.currency_symbol,
    minor_units = EXCLUDED.minor_units,
    updated_at = now();

INSERT INTO public.customer_category (category_code, category_name)
VALUES
  ('CORP', 'Corporativo'),
  ('GOLD', 'Gold'),
  ('PLAT', 'Platinum'),
  ('REG', 'Regular'),
  ('SILV', 'Silver')
ON CONFLICT (category_code) DO UPDATE
SET category_name = EXCLUDED.category_name,
    updated_at = now();

INSERT INTO public.delay_reason_type (reason_code, reason_name)
VALUES
  ('ATC', 'Control de trafico aereo'),
  ('CREW', 'Disponibilidad de tripulacion'),
  ('MX', 'Mantenimiento'),
  ('OPS', 'Operacion aeroportuaria'),
  ('SEC', 'Seguridad'),
  ('WX', 'Condiciones meteorologicas')
ON CONFLICT (reason_code) DO UPDATE
SET reason_name = EXCLUDED.reason_name,
    updated_at = now();

INSERT INTO public.document_type (type_code, type_name)
VALUES
  ('DL', 'Licencia de conduccion'),
  ('NIT', 'Documento tributario'),
  ('NID', 'Documento nacional'),
  ('PASS', 'Pasaporte'),
  ('RES', 'Tarjeta de residencia')
ON CONFLICT (type_code) DO UPDATE
SET type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO public.flight_status (status_code, status_name)
VALUES
  ('ARRIVED', 'Arribado'),
  ('BOARDING', 'En abordaje'),
  ('CANCELLED', 'Cancelado'),
  ('DELAYED', 'Demorado'),
  ('DEPARTED', 'Despegado'),
  ('DIVERTED', 'Desviado'),
  ('SCHEDULED', 'Programado')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.invoice_status (status_code, status_name)
VALUES
  ('ISSUED', 'Emitida'),
  ('OVERDUE', 'Vencida'),
  ('PAID', 'Pagada'),
  ('PARTIAL', 'Pago parcial'),
  ('VOID', 'Anulada')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.maintenance_type (type_code, type_name)
VALUES
  ('A_CHECK', 'A-Check'),
  ('C_CHECK', 'C-Check'),
  ('CABIN', 'Cabina'),
  ('ENGINE', 'Motor'),
  ('LINE', 'Linea'),
  ('UNSCHED', 'No programado')
ON CONFLICT (type_code) DO UPDATE
SET type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO public.payment_method (method_code, method_name)
VALUES
  ('BANK_TRANSFER', 'Transferencia bancaria'),
  ('CASH', 'Efectivo'),
  ('CREDIT_CARD', 'Tarjeta de credito'),
  ('DEBIT_CARD', 'Tarjeta debito'),
  ('MILES', 'Millas'),
  ('WALLET', 'Billetera digital')
ON CONFLICT (method_code) DO UPDATE
SET method_name = EXCLUDED.method_name,
    updated_at = now();

INSERT INTO public.payment_status (status_code, status_name)
VALUES
  ('AUTHORIZED', 'Autorizado'),
  ('CANCELLED', 'Cancelado'),
  ('CAPTURED', 'Capturado'),
  ('FAILED', 'Fallido'),
  ('PENDING', 'Pendiente'),
  ('REFUNDED', 'Reembolsado')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.person_type (type_code, type_name)
VALUES
  ('ADULT', 'Adulto'),
  ('CHILD', 'Menor'),
  ('CONTRACTOR', 'Contratista'),
  ('EMPLOYEE', 'Empleado'),
  ('INFANT', 'Infante')
ON CONFLICT (type_code) DO UPDATE
SET type_name = EXCLUDED.type_name,
    updated_at = now();

INSERT INTO public.reservation_status (status_code, status_name)
VALUES
  ('CANCELLED', 'Cancelada'),
  ('CONFIRMED', 'Confirmada'),
  ('EXPIRED', 'Expirada'),
  ('HOLD', 'En espera'),
  ('TICKETED', 'Tiquete emitido')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.sale_channel (channel_code, channel_name)
VALUES
  ('AGENCY', 'Agencia'),
  ('AIRPORT_COUNTER', 'Mostrador de aeropuerto'),
  ('CALL_CENTER', 'Call center'),
  ('CORPORATE', 'Portal corporativo'),
  ('MOBILE_APP', 'Aplicacion movil'),
  ('WEB', 'Web')
ON CONFLICT (channel_code) DO UPDATE
SET channel_name = EXCLUDED.channel_name,
    updated_at = now();

INSERT INTO public.security_permission (permission_code, permission_name, permission_description)
VALUES
  ('ISSUE_INVOICES', 'Emitir facturas', 'Permite emitir y consultar facturas de venta.'),
  ('ISSUE_TICKETS', 'Emitir tiquetes', 'Permite crear y actualizar tickets asociados a una venta.'),
  ('MANAGE_AIRCRAFT', 'Administrar flota', 'Permite registrar aeronaves, cabinas y asientos.'),
  ('MANAGE_FLIGHTS', 'Administrar vuelos', 'Permite crear vuelos, segmentos y estados operativos.'),
  ('MANAGE_RESERVATIONS', 'Administrar reservas', 'Permite crear, modificar o cancelar reservas.'),
  ('MANAGE_USERS', 'Administrar usuarios', 'Permite crear usuarios y asignarles roles.'),
  ('PROCESS_REFUNDS', 'Procesar reembolsos', 'Permite registrar devoluciones ligadas a pagos.'),
  ('REGISTER_PAYMENTS', 'Registrar pagos', 'Permite autorizar y registrar pagos y transacciones.'),
  ('VALIDATE_BOARDING', 'Validar abordaje', 'Permite ejecutar validaciones de boarding.'),
  ('VIEW_CUSTOMERS', 'Consultar clientes', 'Permite ver informacion comercial y de lealtad.'),
  ('VIEW_REPORTS', 'Consultar reportes', 'Permite acceder a tableros e indicadores.'),
  ('WRITE_CUSTOMERS', 'Actualizar clientes', 'Permite editar datos maestros del cliente.')
ON CONFLICT (permission_code) DO UPDATE
SET permission_name = EXCLUDED.permission_name,
    permission_description = EXCLUDED.permission_description,
    updated_at = now();

INSERT INTO public.security_role (role_code, role_name, role_description)
VALUES
  ('CS_AGENT', 'Agente de servicio', 'Gestiona atencion al cliente, reservas y cambios simples.'),
  ('FINANCE', 'Finanzas', 'Administra pagos, facturas y conciliacion.'),
  ('OPS_CTRL', 'Control operacional', 'Administra vuelos, demoras y eventos de viaje.'),
  ('SALES_AGENT', 'Agente comercial', 'Gestiona ventas, reservas y emision de tickets.'),
  ('SYS_ADMIN', 'Administrador del sistema', 'Administra seguridad, parametria y operacion completa.')
ON CONFLICT (role_code) DO UPDATE
SET role_name = EXCLUDED.role_name,
    role_description = EXCLUDED.role_description,
    updated_at = now();

INSERT INTO public.tax (tax_code, tax_name, rate_percentage, effective_from, effective_to)
VALUES
  ('AIRPORT_FEE', 'Tasa aeroportuaria', 12.00, DATE '2024-01-01', NULL),
  ('SECURITY_FEE', 'Tasa de seguridad', 4.00, DATE '2024-01-01', NULL),
  ('VAT_19', 'IVA 19', 19.00, DATE '2024-01-01', NULL)
ON CONFLICT (tax_code) DO UPDATE
SET tax_name = EXCLUDED.tax_name,
    rate_percentage = EXCLUDED.rate_percentage,
    effective_from = EXCLUDED.effective_from,
    effective_to = EXCLUDED.effective_to,
    updated_at = now();

INSERT INTO public.ticket_status (status_code, status_name)
VALUES
  ('CHECKED_IN', 'Chequeado'),
  ('EXCHANGED', 'Cambiado'),
  ('FLOWN', 'Volado'),
  ('ISSUED', 'Emitido'),
  ('REFUNDED', 'Reembolsado'),
  ('VOID', 'Anulado')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.time_zone (time_zone_name, utc_offset_minutes)
VALUES
  ('America/Bogota', -300),
  ('America/Mexico_City', -360),
  ('America/New_York', -300),
  ('America/Sao_Paulo', -180),
  ('Europe/London', 0),
  ('Europe/Madrid', 60),
  ('UTC', 0)
ON CONFLICT (time_zone_name) DO UPDATE
SET utc_offset_minutes = EXCLUDED.utc_offset_minutes,
    updated_at = now();

INSERT INTO public.user_status (status_code, status_name)
VALUES
  ('ACTIVE', 'Activo'),
  ('INACTIVE', 'Inactivo'),
  ('LOCKED', 'Bloqueado'),
  ('PENDING', 'Pendiente'),
  ('SUSPENDED', 'Suspendido')
ON CONFLICT (status_code) DO UPDATE
SET status_name = EXCLUDED.status_name,
    updated_at = now();

INSERT INTO public.role_permission (security_role_id, security_permission_id, granted_at)
SELECT sr.security_role_id, sp.security_permission_id, now()
FROM public.security_role sr
JOIN public.security_permission sp
  ON (
    sr.role_code = 'SYS_ADMIN'
    OR (sr.role_code = 'SALES_AGENT' AND sp.permission_code IN ('VIEW_CUSTOMERS', 'WRITE_CUSTOMERS', 'MANAGE_RESERVATIONS', 'ISSUE_TICKETS', 'VIEW_REPORTS'))
    OR (sr.role_code = 'FINANCE' AND sp.permission_code IN ('REGISTER_PAYMENTS', 'ISSUE_INVOICES', 'PROCESS_REFUNDS', 'VIEW_REPORTS'))
    OR (sr.role_code = 'OPS_CTRL' AND sp.permission_code IN ('MANAGE_FLIGHTS', 'MANAGE_AIRCRAFT', 'VALIDATE_BOARDING', 'VIEW_REPORTS'))
    OR (sr.role_code = 'CS_AGENT' AND sp.permission_code IN ('VIEW_CUSTOMERS', 'MANAGE_RESERVATIONS', 'VALIDATE_BOARDING'))
  )
ON CONFLICT (security_role_id, security_permission_id) DO NOTHING;

-- Geografia y referencia operacional

INSERT INTO public.country (continent_id, iso_alpha2, iso_alpha3, country_name)
SELECT ct.continent_id, seed.iso_alpha2, seed.iso_alpha3, seed.country_name
FROM (
  VALUES
    ('SA', 'BR', 'BRA', 'Brazil'),
    ('CO', 'CO', 'COL', 'Colombia'),
    ('EU', 'ES', 'ESP', 'Spain'),
    ('NA', 'MX', 'MEX', 'Mexico'),
    ('NA', 'US', 'USA', 'United States')
) AS seed(continent_code, iso_alpha2, iso_alpha3, country_name)
JOIN public.continent ct
  ON ct.continent_code = seed.continent_code
ON CONFLICT (iso_alpha2) DO UPDATE
SET continent_id = EXCLUDED.continent_id,
    iso_alpha3 = EXCLUDED.iso_alpha3,
    country_name = EXCLUDED.country_name,
    updated_at = now();

INSERT INTO public.state_province (country_id, state_code, state_name)
SELECT c.country_id, seed.state_code, seed.state_name
FROM (
  VALUES
    ('BR', 'SP', 'Sao Paulo'),
    ('CO', 'ANT', 'Antioquia'),
    ('CO', 'BOG', 'Bogota D.C.'),
    ('ES', 'MD', 'Comunidad de Madrid'),
    ('MX', 'CMX', 'Ciudad de Mexico'),
    ('US', 'FL', 'Florida')
) AS seed(country_code, state_code, state_name)
JOIN public.country c
  ON c.iso_alpha2 = seed.country_code
ON CONFLICT (country_id, state_name) DO UPDATE
SET state_code = EXCLUDED.state_code,
    updated_at = now();

INSERT INTO public.city (state_province_id, time_zone_id, city_name)
SELECT sp.state_province_id, tz.time_zone_id, seed.city_name
FROM (
  VALUES
    ('Bogota D.C.', 'America/Bogota', 'Bogota'),
    ('Antioquia', 'America/Bogota', 'Rionegro'),
    ('Florida', 'America/New_York', 'Miami'),
    ('Comunidad de Madrid', 'Europe/Madrid', 'Madrid'),
    ('Ciudad de Mexico', 'America/Mexico_City', 'Mexico City'),
    ('Sao Paulo', 'America/Sao_Paulo', 'Sao Paulo')
) AS seed(state_name, time_zone_name, city_name)
JOIN public.state_province sp
  ON sp.state_name = seed.state_name
JOIN public.time_zone tz
  ON tz.time_zone_name = seed.time_zone_name
ON CONFLICT (state_province_id, city_name) DO UPDATE
SET time_zone_id = EXCLUDED.time_zone_id,
    updated_at = now();

INSERT INTO public.district (city_id, district_name)
SELECT c.city_id, seed.district_name
FROM (
  VALUES
    ('Bogota', 'Fontibon'),
    ('Bogota', 'Zona Industrial'),
    ('Madrid', 'Barajas'),
    ('Mexico City', 'Venustiano Carranza'),
    ('Miami', 'Miami-Dade'),
    ('Rionegro', 'Llanogrande'),
    ('Sao Paulo', 'Guarulhos')
) AS seed(city_name, district_name)
JOIN public.city c
  ON c.city_name = seed.city_name
ON CONFLICT (city_id, district_name) DO UPDATE
SET updated_at = now();

INSERT INTO public.address (address_id, district_id, address_line_1, address_line_2, postal_code, latitude, longitude)
SELECT seed.address_id, d.district_id, seed.address_line_1, seed.address_line_2, seed.postal_code, seed.latitude, seed.longitude
FROM (
  VALUES
    ('40000000-0000-0000-0000-000000000001'::uuid, 'Fontibon', 'Avenida El Dorado 103-09', 'Terminal 1', '110911', 4.7015940::numeric, -74.1469470::numeric),
    ('40000000-0000-0000-0000-000000000002'::uuid, 'Llanogrande', 'Via Aeropuerto Jose Maria Cordova Km 3.5', NULL, '054047', 6.1645360::numeric, -75.4231190::numeric),
    ('40000000-0000-0000-0000-000000000003'::uuid, 'Miami-Dade', '2100 NW 42nd Avenue', NULL, '33142', 25.7958650::numeric, -80.2870460::numeric),
    ('40000000-0000-0000-0000-000000000004'::uuid, 'Barajas', 'Av de la Hispanidad s/n', 'Terminal 4', '28042', 40.4913530::numeric, -3.5931900::numeric),
    ('40000000-0000-0000-0000-000000000005'::uuid, 'Venustiano Carranza', 'Capitan Carlos Leon s/n', 'Terminal 2', '15620', 19.4363030::numeric, -99.0720970::numeric),
    ('40000000-0000-0000-0000-000000000006'::uuid, 'Zona Industrial', 'Carrera 96G 16C-39', 'Hangar 5', '110931', 4.6902000::numeric, -74.1399000::numeric)
) AS seed(address_id, district_name, address_line_1, address_line_2, postal_code, latitude, longitude)
JOIN public.district d
  ON d.district_name = seed.district_name
ON CONFLICT (address_id) DO UPDATE
SET district_id = EXCLUDED.district_id,
    address_line_1 = EXCLUDED.address_line_1,
    address_line_2 = EXCLUDED.address_line_2,
    postal_code = EXCLUDED.postal_code,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    updated_at = now();

INSERT INTO public.airline (home_country_id, airline_code, airline_name, iata_code, icao_code, is_active)
SELECT c.country_id, seed.airline_code, seed.airline_name, seed.iata_code, seed.icao_code, seed.is_active
FROM (
  VALUES
    ('CO', 'FLY', 'FLY Airlines', 'FY', 'FLY', true),
    ('ES', 'IBA', 'Ibero Atlantic', 'IA', 'IBA', true),
    ('US', 'NVA', 'Nova America', 'NV', 'NVA', true)
) AS seed(country_code, airline_code, airline_name, iata_code, icao_code, is_active)
JOIN public.country c
  ON c.iso_alpha2 = seed.country_code
ON CONFLICT (airline_code) DO UPDATE
SET home_country_id = EXCLUDED.home_country_id,
    airline_name = EXCLUDED.airline_name,
    iata_code = EXCLUDED.iata_code,
    icao_code = EXCLUDED.icao_code,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.exchange_rate (from_currency_id, to_currency_id, effective_date, rate_value)
SELECT cf.currency_id, ct.currency_id, seed.effective_date, seed.rate_value
FROM (
  VALUES
    ('COP', 'USD', DATE '2026-03-01', 0.00025500::numeric),
    ('USD', 'COP', DATE '2026-03-01', 3921.56000000::numeric),
    ('EUR', 'USD', DATE '2026-03-01', 1.08750000::numeric),
    ('USD', 'EUR', DATE '2026-03-01', 0.91954000::numeric),
    ('MXN', 'USD', DATE '2026-03-01', 0.05840000::numeric),
    ('USD', 'MXN', DATE '2026-03-01', 17.12330000::numeric)
) AS seed(from_code, to_code, effective_date, rate_value)
JOIN public.currency cf
  ON cf.iso_currency_code = seed.from_code
JOIN public.currency ct
  ON ct.iso_currency_code = seed.to_code
ON CONFLICT (from_currency_id, to_currency_id, effective_date) DO UPDATE
SET rate_value = EXCLUDED.rate_value,
    updated_at = now();

INSERT INTO public.airport (address_id, airport_name, iata_code, icao_code, is_active)
SELECT seed.address_id, seed.airport_name, seed.iata_code, seed.icao_code, seed.is_active
FROM (
  VALUES
    ('40000000-0000-0000-0000-000000000001'::uuid, 'El Dorado International Airport', 'BOG', 'SKBO', true),
    ('40000000-0000-0000-0000-000000000002'::uuid, 'Jose Maria Cordova International Airport', 'MDE', 'SKRG', true),
    ('40000000-0000-0000-0000-000000000003'::uuid, 'Miami International Airport', 'MIA', 'KMIA', true),
    ('40000000-0000-0000-0000-000000000004'::uuid, 'Adolfo Suarez Madrid-Barajas Airport', 'MAD', 'LEMD', true),
    ('40000000-0000-0000-0000-000000000005'::uuid, 'Benito Juarez International Airport', 'MEX', 'MMMX', true)
  ) AS seed(address_id, airport_name, iata_code, icao_code, is_active)
ON CONFLICT (iata_code) DO UPDATE
SET address_id = EXCLUDED.address_id,
    airport_name = EXCLUDED.airport_name,
    icao_code = EXCLUDED.icao_code,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.terminal (airport_id, terminal_code, terminal_name)
SELECT ap.airport_id, seed.terminal_code, seed.terminal_name
FROM (
  VALUES
    ('BOG', 'T1', 'Terminal 1'),
    ('MDE', 'T1', 'Terminal Principal'),
    ('MIA', 'D', 'North Terminal D'),
    ('MAD', 'T4', 'Terminal 4'),
    ('MEX', 'T2', 'Terminal 2')
) AS seed(iata_code, terminal_code, terminal_name)
JOIN public.airport ap
  ON ap.iata_code = seed.iata_code
ON CONFLICT (airport_id, terminal_code) DO UPDATE
SET terminal_name = EXCLUDED.terminal_name,
    updated_at = now();

INSERT INTO public.boarding_gate (terminal_id, gate_code, is_active)
SELECT t.terminal_id, seed.gate_code, seed.is_active
FROM (
  VALUES
    ('BOG', 'T1', 'A12', true),
    ('BOG', 'T1', 'A18', true),
    ('MDE', 'T1', '07', true),
    ('MIA', 'D', 'D14', true),
    ('MAD', 'T4', 'S08', true),
    ('MEX', 'T2', 'B05', true)
) AS seed(iata_code, terminal_code, gate_code, is_active)
JOIN public.airport ap
  ON ap.iata_code = seed.iata_code
JOIN public.terminal t
  ON t.airport_id = ap.airport_id
 AND t.terminal_code = seed.terminal_code
ON CONFLICT (terminal_id, gate_code) DO UPDATE
SET is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.runway (airport_id, runway_code, length_meters, surface_type)
SELECT ap.airport_id, seed.runway_code, seed.length_meters, seed.surface_type
FROM (
  VALUES
    ('BOG', '13L/31R', 3800, 'ASPHALT'),
    ('MDE', '01/19', 3557, 'ASPHALT'),
    ('MIA', '08R/26L', 3960, 'CONCRETE'),
    ('MAD', '18L/36R', 4400, 'ASPHALT'),
    ('MEX', '05L/23R', 3900, 'CONCRETE')
  ) AS seed(iata_code, runway_code, length_meters, surface_type)
JOIN public.airport ap
  ON ap.iata_code = seed.iata_code
ON CONFLICT (airport_id, runway_code) DO UPDATE
SET length_meters = EXCLUDED.length_meters,
    surface_type = EXCLUDED.surface_type,
    updated_at = now();

INSERT INTO public.airport_regulation (airport_id, regulation_code, regulation_title, issuing_authority, effective_from, effective_to)
SELECT ap.airport_id, seed.regulation_code, seed.regulation_title, seed.issuing_authority, seed.effective_from, seed.effective_to
FROM (
  VALUES
    ('BOG', 'SLOT-OPS', 'Ventanas operacionales y asignacion de slots', 'Aerocivil', DATE '2025-01-01', NULL),
    ('MDE', 'WX-MIN', 'Minimos operacionales por meteorologia', 'Aerocivil', DATE '2025-01-01', NULL),
    ('MIA', 'SEC-STER', 'Control de acceso a zona esteril', 'FAA', DATE '2025-01-01', NULL),
    ('MAD', 'SCHENGEN-SEP', 'Segregacion Schengen y no Schengen', 'AENA', DATE '2025-01-01', NULL),
    ('MEX', 'BAG-CTRL', 'Control de equipaje y trazabilidad', 'AFAC', DATE '2025-01-01', NULL)
  ) AS seed(iata_code, regulation_code, regulation_title, issuing_authority, effective_from, effective_to)
JOIN public.airport ap
  ON ap.iata_code = seed.iata_code
ON CONFLICT (airport_id, regulation_code) DO UPDATE
SET regulation_title = EXCLUDED.regulation_title,
    issuing_authority = EXCLUDED.issuing_authority,
    effective_from = EXCLUDED.effective_from,
    effective_to = EXCLUDED.effective_to,
    updated_at = now();

INSERT INTO public.aircraft_model (aircraft_manufacturer_id, model_code, model_name, max_range_km)
SELECT am.aircraft_manufacturer_id, seed.model_code, seed.model_name, seed.max_range_km
FROM (
  VALUES
    ('Airbus', 'A320N', 'A320neo', 6300),
    ('Boeing', 'B788', '787-8 Dreamliner', 13620),
    ('Embraer', 'E190-E2', 'E190-E2', 5278)
) AS seed(manufacturer_name, model_code, model_name, max_range_km)
JOIN public.aircraft_manufacturer am
  ON am.manufacturer_name = seed.manufacturer_name
ON CONFLICT (aircraft_manufacturer_id, model_code) DO UPDATE
SET model_name = EXCLUDED.model_name,
    max_range_km = EXCLUDED.max_range_km,
    updated_at = now();

INSERT INTO public.aircraft (airline_id, aircraft_model_id, registration_number, serial_number, in_service_on, retired_on)
SELECT al.airline_id, am.aircraft_model_id, seed.registration_number, seed.serial_number, seed.in_service_on, seed.retired_on
FROM (
  VALUES
    ('FLY', 'A320N', 'HK-5500', 'FLY320001', DATE '2020-06-15', NULL),
    ('FLY', 'B788', 'HK-7870', 'FLY787001', DATE '2021-09-01', NULL),
    ('NVA', 'E190-E2', 'N803NV', 'NVA190001', DATE '2022-03-20', NULL)
) AS seed(airline_code, model_code, registration_number, serial_number, in_service_on, retired_on)
JOIN public.airline al
  ON al.airline_code = seed.airline_code
JOIN public.aircraft_model am
  ON am.model_code = seed.model_code
ON CONFLICT (registration_number) DO UPDATE
SET airline_id = EXCLUDED.airline_id,
    aircraft_model_id = EXCLUDED.aircraft_model_id,
    serial_number = EXCLUDED.serial_number,
    in_service_on = EXCLUDED.in_service_on,
    retired_on = EXCLUDED.retired_on,
    updated_at = now();

INSERT INTO public.aircraft_cabin (aircraft_id, cabin_class_id, cabin_code, deck_number)
SELECT a.aircraft_id, cc.cabin_class_id, seed.cabin_code, seed.deck_number
FROM (
  VALUES
    ('HK-5500', 'J', 'J', 1),
    ('HK-5500', 'Y', 'Y', 1),
    ('HK-7870', 'J', 'J', 1),
    ('HK-7870', 'Y', 'Y', 1),
    ('N803NV', 'Y', 'Y', 1)
  ) AS seed(registration_number, class_code, cabin_code, deck_number)
JOIN public.aircraft a
  ON a.registration_number = seed.registration_number
JOIN public.cabin_class cc
  ON cc.class_code = seed.class_code
ON CONFLICT (aircraft_id, cabin_code) DO UPDATE
SET cabin_class_id = EXCLUDED.cabin_class_id,
    deck_number = EXCLUDED.deck_number,
    updated_at = now();

INSERT INTO public.aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT ac.aircraft_cabin_id, gs.row_no, col.seat_column_code, col.is_window, col.is_aisle, false
FROM public.aircraft_cabin ac
JOIN public.aircraft a
  ON a.aircraft_id = ac.aircraft_id
CROSS JOIN generate_series(1, 3) AS gs(row_no)
CROSS JOIN (
  VALUES
    ('A', true, false),
    ('C', false, true),
    ('D', false, true),
    ('F', true, false)
) AS col(seat_column_code, is_window, is_aisle)
WHERE a.registration_number = 'HK-5500'
  AND ac.cabin_code = 'J'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO public.aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT ac.aircraft_cabin_id, gs.row_no, col.seat_column_code, col.is_window, col.is_aisle, gs.row_no IN (12, 13)
FROM public.aircraft_cabin ac
JOIN public.aircraft a
  ON a.aircraft_id = ac.aircraft_id
CROSS JOIN generate_series(5, 24) AS gs(row_no)
CROSS JOIN (
  VALUES
    ('A', true, false),
    ('B', false, false),
    ('C', false, true),
    ('D', false, true),
    ('E', false, false),
    ('F', true, false)
) AS col(seat_column_code, is_window, is_aisle)
WHERE a.registration_number = 'HK-5500'
  AND ac.cabin_code = 'Y'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO public.aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT ac.aircraft_cabin_id, gs.row_no, col.seat_column_code, col.is_window, col.is_aisle, false
FROM public.aircraft_cabin ac
JOIN public.aircraft a
  ON a.aircraft_id = ac.aircraft_id
CROSS JOIN generate_series(1, 5) AS gs(row_no)
CROSS JOIN (
  VALUES
    ('A', true, false),
    ('D', false, true),
    ('G', false, true),
    ('K', true, false)
) AS col(seat_column_code, is_window, is_aisle)
WHERE a.registration_number = 'HK-7870'
  AND ac.cabin_code = 'J'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO public.aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT ac.aircraft_cabin_id, gs.row_no, col.seat_column_code, col.is_window, col.is_aisle, gs.row_no IN (15, 16)
FROM public.aircraft_cabin ac
JOIN public.aircraft a
  ON a.aircraft_id = ac.aircraft_id
CROSS JOIN generate_series(10, 29) AS gs(row_no)
CROSS JOIN (
  VALUES
    ('A', true, false),
    ('C', false, true),
    ('D', false, true),
    ('F', false, true),
    ('H', false, true),
    ('K', true, false)
) AS col(seat_column_code, is_window, is_aisle)
WHERE a.registration_number = 'HK-7870'
  AND ac.cabin_code = 'Y'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO public.aircraft_seat (aircraft_cabin_id, seat_row_number, seat_column_code, is_window, is_aisle, is_exit_row)
SELECT ac.aircraft_cabin_id, gs.row_no, col.seat_column_code, col.is_window, col.is_aisle, gs.row_no = 12
FROM public.aircraft_cabin ac
JOIN public.aircraft a
  ON a.aircraft_id = ac.aircraft_id
CROSS JOIN generate_series(5, 20) AS gs(row_no)
CROSS JOIN (
  VALUES
    ('A', true, false),
    ('B', false, false),
    ('C', false, true),
    ('D', false, true),
    ('E', true, false)
) AS col(seat_column_code, is_window, is_aisle)
WHERE a.registration_number = 'N803NV'
  AND ac.cabin_code = 'Y'
ON CONFLICT (aircraft_cabin_id, seat_row_number, seat_column_code) DO UPDATE
SET is_window = EXCLUDED.is_window,
    is_aisle = EXCLUDED.is_aisle,
    is_exit_row = EXCLUDED.is_exit_row,
    updated_at = now();

INSERT INTO public.maintenance_provider (address_id, provider_name, contact_name)
VALUES
  ('40000000-0000-0000-0000-000000000006'::uuid, 'AeroAndes MRO Bogota', 'Mauricio Cardenas'),
  ('40000000-0000-0000-0000-000000000003'::uuid, 'Atlantic TechOps Miami', 'Helen Parker')
ON CONFLICT (provider_name) DO UPDATE
SET address_id = EXCLUDED.address_id,
    contact_name = EXCLUDED.contact_name,
    updated_at = now();

INSERT INTO public.maintenance_event (
  maintenance_event_id,
  aircraft_id,
  maintenance_type_id,
  maintenance_provider_id,
  status_code,
  started_at,
  completed_at,
  notes
)
SELECT
  seed.maintenance_event_id,
  a.aircraft_id,
  mt.maintenance_type_id,
  mp.maintenance_provider_id,
  seed.status_code,
  seed.started_at,
  seed.completed_at,
  seed.notes
FROM (
  VALUES
    ('60000000-0000-0000-0000-000000000001'::uuid, 'HK-5500', 'LINE', 'AeroAndes MRO Bogota', 'COMPLETED', TIMESTAMPTZ '2026-03-09 22:10:00-05', TIMESTAMPTZ '2026-03-10 01:15:00-05', 'Inspeccion previa a operacion domestica.'),
    ('60000000-0000-0000-0000-000000000002'::uuid, 'HK-7870', 'A_CHECK', 'Atlantic TechOps Miami', 'COMPLETED', TIMESTAMPTZ '2026-03-08 23:30:00-05', TIMESTAMPTZ '2026-03-09 05:45:00-05', 'Revision de rutina para operacion internacional.')
  ) AS seed(maintenance_event_id, registration_number, type_code, provider_name, status_code, started_at, completed_at, notes)
JOIN public.aircraft a
  ON a.registration_number = seed.registration_number
JOIN public.maintenance_type mt
  ON mt.type_code = seed.type_code
LEFT JOIN public.maintenance_provider mp
  ON mp.provider_name = seed.provider_name
ON CONFLICT (maintenance_event_id) DO UPDATE
SET aircraft_id = EXCLUDED.aircraft_id,
    maintenance_type_id = EXCLUDED.maintenance_type_id,
    maintenance_provider_id = EXCLUDED.maintenance_provider_id,
    status_code = EXCLUDED.status_code,
    started_at = EXCLUDED.started_at,
    completed_at = EXCLUDED.completed_at,
    notes = EXCLUDED.notes,
    updated_at = now();

INSERT INTO public.fare_class (cabin_class_id, fare_class_code, fare_class_name, is_refundable_by_default)
SELECT cc.cabin_class_id, seed.fare_class_code, seed.fare_class_name, seed.is_refundable_by_default
FROM (
  VALUES
    ('J', 'JF', 'Business Flex', true),
    ('W', 'WF', 'Premium Flex', true),
    ('Y', 'YB', 'Economy Basic', false),
    ('Y', 'YF', 'Economy Flex', true)
) AS seed(class_code, fare_class_code, fare_class_name, is_refundable_by_default)
JOIN public.cabin_class cc
  ON cc.class_code = seed.class_code
ON CONFLICT (fare_class_code) DO UPDATE
SET cabin_class_id = EXCLUDED.cabin_class_id,
    fare_class_name = EXCLUDED.fare_class_name,
    is_refundable_by_default = EXCLUDED.is_refundable_by_default,
    updated_at = now();

INSERT INTO public.fare (
  airline_id,
  origin_airport_id,
  destination_airport_id,
  fare_class_id,
  currency_id,
  fare_code,
  base_amount,
  valid_from,
  valid_to,
  baggage_allowance_qty,
  change_penalty_amount,
  refund_penalty_amount
)
SELECT
  al.airline_id,
  ao.airport_id,
  ad.airport_id,
  fc.fare_class_id,
  cu.currency_id,
  seed.fare_code,
  seed.base_amount,
  seed.valid_from,
  seed.valid_to,
  seed.baggage_allowance_qty,
  seed.change_penalty_amount,
  seed.refund_penalty_amount
FROM (
  VALUES
    ('FLY', 'BOG', 'MAD', 'YF', 'USD', 'FLY-BOGMAD-YF-2026', 980.00::numeric, DATE '2026-01-01', DATE '2026-12-31', 1, 120.00::numeric, 180.00::numeric),
    ('FLY', 'BOG', 'MAD', 'JF', 'USD', 'FLY-BOGMAD-JF-2026', 2450.00::numeric, DATE '2026-01-01', DATE '2026-12-31', 2, 0.00::numeric, 150.00::numeric),
    ('FLY', 'BOG', 'MDE', 'YB', 'COP', 'FLY-BOGMDE-YB-2026', 310000.00::numeric, DATE '2026-01-01', DATE '2026-12-31', 1, 90000.00::numeric, 150000.00::numeric),
    ('FLY', 'BOG', 'MIA', 'JF', 'USD', 'FLY-BOGMIA-JF-2026', 1280.00::numeric, DATE '2026-01-01', DATE '2026-12-31', 2, 0.00::numeric, 200.00::numeric),
    ('FLY', 'BOG', 'MIA', 'YF', 'USD', 'FLY-BOGMIA-YF-2026', 620.00::numeric, DATE '2026-01-01', DATE '2026-12-31', 1, 90.00::numeric, 120.00::numeric)
  ) AS seed(airline_code, origin_iata, destination_iata, fare_class_code, currency_code, fare_code, base_amount, valid_from, valid_to, baggage_allowance_qty, change_penalty_amount, refund_penalty_amount)
JOIN public.airline al
  ON al.airline_code = seed.airline_code
JOIN public.airport ao
  ON ao.iata_code = seed.origin_iata
JOIN public.airport ad
  ON ad.iata_code = seed.destination_iata
JOIN public.fare_class fc
  ON fc.fare_class_code = seed.fare_class_code
JOIN public.currency cu
  ON cu.iso_currency_code = seed.currency_code
ON CONFLICT (fare_code) DO UPDATE
SET airline_id = EXCLUDED.airline_id,
    origin_airport_id = EXCLUDED.origin_airport_id,
    destination_airport_id = EXCLUDED.destination_airport_id,
    fare_class_id = EXCLUDED.fare_class_id,
    currency_id = EXCLUDED.currency_id,
    base_amount = EXCLUDED.base_amount,
    valid_from = EXCLUDED.valid_from,
    valid_to = EXCLUDED.valid_to,
    baggage_allowance_qty = EXCLUDED.baggage_allowance_qty,
    change_penalty_amount = EXCLUDED.change_penalty_amount,
    refund_penalty_amount = EXCLUDED.refund_penalty_amount,
    updated_at = now();

INSERT INTO public.flight (airline_id, aircraft_id, flight_status_id, flight_number, service_date)
SELECT al.airline_id, a.aircraft_id, fs.flight_status_id, seed.flight_number, seed.service_date
FROM (
  VALUES
    ('FLY', 'HK-7870', 'ARRIVED', 'FY210', DATE '2026-03-10'),
    ('FLY', 'HK-7870', 'ARRIVED', 'FY711', DATE '2026-03-10'),
    ('FLY', 'HK-5500', 'ARRIVED', 'FY101', DATE '2026-03-12'),
    ('FLY', 'HK-7870', 'ARRIVED', 'FY305', DATE '2026-03-15')
  ) AS seed(airline_code, registration_number, status_code, flight_number, service_date)
JOIN public.airline al
  ON al.airline_code = seed.airline_code
JOIN public.aircraft a
  ON a.registration_number = seed.registration_number
JOIN public.flight_status fs
  ON fs.status_code = seed.status_code
ON CONFLICT (airline_id, flight_number, service_date) DO UPDATE
SET aircraft_id = EXCLUDED.aircraft_id,
    flight_status_id = EXCLUDED.flight_status_id,
    updated_at = now();

INSERT INTO public.flight_segment (
  flight_segment_id,
  flight_id,
  origin_airport_id,
  destination_airport_id,
  segment_number,
  scheduled_departure_at,
  scheduled_arrival_at,
  actual_departure_at,
  actual_arrival_at
)
SELECT
  seed.flight_segment_id,
  f.flight_id,
  ao.airport_id,
  ad.airport_id,
  seed.segment_number,
  seed.scheduled_departure_at,
  seed.scheduled_arrival_at,
  seed.actual_departure_at,
  seed.actual_arrival_at
FROM (
  VALUES
    ('61000000-0000-0000-0000-000000000001'::uuid, 'FY210', DATE '2026-03-10', 'BOG', 'MIA', 1, TIMESTAMPTZ '2026-03-10 08:15:00-05', TIMESTAMPTZ '2026-03-10 12:30:00-04', TIMESTAMPTZ '2026-03-10 08:28:00-05', TIMESTAMPTZ '2026-03-10 12:41:00-04'),
    ('61000000-0000-0000-0000-000000000002'::uuid, 'FY711', DATE '2026-03-10', 'MIA', 'MAD', 1, TIMESTAMPTZ '2026-03-10 16:00:00-04', TIMESTAMPTZ '2026-03-11 05:45:00+01', TIMESTAMPTZ '2026-03-10 16:22:00-04', TIMESTAMPTZ '2026-03-11 05:58:00+01'),
    ('61000000-0000-0000-0000-000000000003'::uuid, 'FY101', DATE '2026-03-12', 'BOG', 'MDE', 1, TIMESTAMPTZ '2026-03-12 09:00:00-05', TIMESTAMPTZ '2026-03-12 10:00:00-05', TIMESTAMPTZ '2026-03-12 09:32:00-05', TIMESTAMPTZ '2026-03-12 10:34:00-05'),
    ('61000000-0000-0000-0000-000000000004'::uuid, 'FY305', DATE '2026-03-15', 'BOG', 'MIA', 1, TIMESTAMPTZ '2026-03-15 07:00:00-05', TIMESTAMPTZ '2026-03-15 11:15:00-04', TIMESTAMPTZ '2026-03-15 07:05:00-05', TIMESTAMPTZ '2026-03-15 11:12:00-04')
  ) AS seed(flight_segment_id, flight_number, service_date, origin_iata, destination_iata, segment_number, scheduled_departure_at, scheduled_arrival_at, actual_departure_at, actual_arrival_at)
JOIN public.flight f
  ON f.flight_number = seed.flight_number
 AND f.service_date = seed.service_date
JOIN public.airport ao
  ON ao.iata_code = seed.origin_iata
JOIN public.airport ad
  ON ad.iata_code = seed.destination_iata
ON CONFLICT (flight_segment_id) DO UPDATE
SET flight_id = EXCLUDED.flight_id,
    origin_airport_id = EXCLUDED.origin_airport_id,
    destination_airport_id = EXCLUDED.destination_airport_id,
    segment_number = EXCLUDED.segment_number,
    scheduled_departure_at = EXCLUDED.scheduled_departure_at,
    scheduled_arrival_at = EXCLUDED.scheduled_arrival_at,
    actual_departure_at = EXCLUDED.actual_departure_at,
    actual_arrival_at = EXCLUDED.actual_arrival_at,
    updated_at = now();

INSERT INTO public.flight_delay (
  flight_delay_id,
  flight_segment_id,
  delay_reason_type_id,
  reported_at,
  delay_minutes,
  notes
)
SELECT
  '62000000-0000-0000-0000-000000000001'::uuid,
  fs.flight_segment_id,
  dr.delay_reason_type_id,
  TIMESTAMPTZ '2026-03-12 08:20:00-05',
  32,
  'Demora operacional por ajuste final de tripulacion.'
FROM public.flight_segment fs
JOIN public.delay_reason_type dr
  ON dr.reason_code = 'CREW'
WHERE fs.flight_segment_id = '61000000-0000-0000-0000-000000000003'::uuid
ON CONFLICT (flight_delay_id) DO UPDATE
SET flight_segment_id = EXCLUDED.flight_segment_id,
    delay_reason_type_id = EXCLUDED.delay_reason_type_id,
    reported_at = EXCLUDED.reported_at,
    delay_minutes = EXCLUDED.delay_minutes,
    notes = EXCLUDED.notes,
    updated_at = now();

COMMIT;
