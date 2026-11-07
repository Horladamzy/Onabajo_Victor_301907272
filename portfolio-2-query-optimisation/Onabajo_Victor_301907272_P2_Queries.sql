-- Show related rental, customer, vehicle records (up to 20).
SELECT t0."rental_id" AS "rental_rental_id",
       t0."start_date" AS "rental_start_date",
       t1."customer_id" AS "customer_customer_id",
       t1."full_name" AS "customer_full_name",
       t2."vehicle_id" AS "vehicle_vehicle_id",
       t2."plate" AS "vehicle_plate"
FROM portfolio."rental" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."vehicle" t2 ON t0."vehicle_id" = t2."vehicle_id"
ORDER BY t0."rental_id", t1."customer_id", t2."vehicle_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."rental_id" AS "rental_rental_id",
       t0."start_date" AS "rental_start_date",
       t1."customer_id" AS "customer_customer_id",
       t1."full_name" AS "customer_full_name",
       t2."vehicle_id" AS "vehicle_vehicle_id",
       t2."plate" AS "vehicle_plate"
FROM portfolio."rental" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."vehicle" t2 ON t0."vehicle_id" = t2."vehicle_id"
ORDER BY t0."rental_id", t1."customer_id", t2."vehicle_id"
LIMIT 20;

-- Find rental records where end_date matches "2026-11-13" (up to 20).
SELECT * FROM portfolio."rental"
WHERE "end_date" IS NOT DISTINCT FROM '2026-11-13'
ORDER BY "rental_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."rental"
WHERE "end_date" IS NOT DISTINCT FROM '2026-11-13'
ORDER BY "rental_id"
LIMIT 20;

-- Count payment records for each rental_id (up to 20 groups).
SELECT "rental_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "rental_id"
ORDER BY record_count DESC, "rental_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "rental_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "rental_id"
ORDER BY record_count DESC, "rental_id" NULLS LAST
LIMIT 20;
