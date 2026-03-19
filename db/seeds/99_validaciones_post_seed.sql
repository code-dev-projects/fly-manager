\set ON_ERROR_STOP on
\echo '99_validaciones_post_seed.sql - validaciones post seed'
SET client_min_messages TO warning;

DROP TABLE IF EXISTS tmp_row_counts;
CREATE TEMP TABLE tmp_row_counts (
  table_name text PRIMARY KEY,
  row_count bigint NOT NULL
);

DO $$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
    ORDER BY table_name
  LOOP
    EXECUTE format(
      'INSERT INTO tmp_row_counts(table_name, row_count) SELECT %L, count(*) FROM public.%I;',
      r.table_name,
      r.table_name
    );
  END LOOP;
END $$;

\echo '== Conteo por tabla =='
SELECT table_name, row_count
FROM tmp_row_counts
ORDER BY row_count DESC, table_name;

DROP TABLE IF EXISTS tmp_threshold_exceptions;
CREATE TEMP TABLE tmp_threshold_exceptions (
  table_name text PRIMARY KEY,
  reason text NOT NULL
);

INSERT INTO tmp_threshold_exceptions(table_name, reason)
VALUES
  ('benefit_type', 'Catalogo controlado'),
  ('boarding_group', 'Catalogo controlado'),
  ('cabin_class', 'Catalogo controlado'),
  ('check_in_status', 'Catalogo controlado'),
  ('contact_type', 'Catalogo controlado'),
  ('continent', 'Catalogo controlado'),
  ('currency', 'Catalogo controlado'),
  ('customer_category', 'Catalogo controlado'),
  ('delay_reason_type', 'Catalogo controlado'),
  ('document_type', 'Catalogo controlado'),
  ('fare_class', 'Catalogo controlado'),
  ('flight_status', 'Catalogo controlado'),
  ('invoice_status', 'Catalogo controlado'),
  ('maintenance_type', 'Catalogo controlado'),
  ('payment_method', 'Catalogo controlado'),
  ('payment_status', 'Catalogo controlado'),
  ('person_type', 'Catalogo controlado'),
  ('reservation_status', 'Catalogo controlado'),
  ('sale_channel', 'Catalogo controlado'),
  ('ticket_status', 'Catalogo controlado'),
  ('time_zone', 'Catalogo controlado'),
  ('user_status', 'Catalogo controlado');

\echo '== Tablas bajo umbral de 1000 sin excepcion controlada =='
SELECT rc.table_name, rc.row_count
FROM tmp_row_counts rc
LEFT JOIN tmp_threshold_exceptions te
  ON te.table_name = rc.table_name
WHERE rc.row_count < 1000
  AND te.table_name IS NULL
ORDER BY rc.row_count, rc.table_name;

\echo '== Tablas bajo umbral de 1000 con excepcion controlada =='
SELECT rc.table_name, rc.row_count, te.reason
FROM tmp_row_counts rc
JOIN tmp_threshold_exceptions te
  ON te.table_name = rc.table_name
WHERE rc.row_count < 1000
ORDER BY rc.row_count, rc.table_name;

\echo '== Tablas sin datos =='
SELECT table_name
FROM tmp_row_counts
WHERE row_count = 0
ORDER BY table_name;

\echo '== Cobertura minima del flujo critico =='
SELECT *
FROM (
  SELECT 'person'::text AS entity_name, count(*)::bigint AS total_rows FROM public.person
  UNION ALL
  SELECT 'customer', count(*) FROM public.customer
  UNION ALL
  SELECT 'reservation', count(*) FROM public.reservation
  UNION ALL
  SELECT 'reservation_passenger', count(*) FROM public.reservation_passenger
  UNION ALL
  SELECT 'sale', count(*) FROM public.sale
  UNION ALL
  SELECT 'ticket', count(*) FROM public.ticket
  UNION ALL
  SELECT 'ticket_segment', count(*) FROM public.ticket_segment
  UNION ALL
  SELECT 'check_in', count(*) FROM public.check_in
  UNION ALL
  SELECT 'boarding_pass', count(*) FROM public.boarding_pass
  UNION ALL
  SELECT 'payment', count(*) FROM public.payment
  UNION ALL
  SELECT 'payment_transaction', count(*) FROM public.payment_transaction
  UNION ALL
  SELECT 'invoice', count(*) FROM public.invoice
  UNION ALL
  SELECT 'invoice_line', count(*) FROM public.invoice_line
) critical_flow
ORDER BY entity_name;
