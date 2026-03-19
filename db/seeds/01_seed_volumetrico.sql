\set ON_ERROR_STOP on
\echo '01_seed_volumetrico.sql - base volumetrica preparada para implementacion'

BEGIN;

-- Este archivo se reserva para la expansion masiva controlada sobre
-- tablas maestras, transaccionales y de detalle. Debe apoyarse sobre
-- 00_seed_canonico.sql y nunca reemplazarlo.

COMMIT;
