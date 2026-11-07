# Vehicle Rental Management System — SQL queries

## 1. Show related rental, customer, vehicle records (up to 20).

```sql
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
```

| rental_rental_id | rental_start_date | customer_customer_id | customer_full_name | vehicle_vehicle_id | vehicle_plate |
| --- | --- | --- | --- | --- | --- |
| 3 | 2026-11-10 | 1 | Alex Morgan | 2 | SYN-204 |

## 2. Find rental records where end_date matches "2026-11-13" (up to 20).

```sql
SELECT * FROM portfolio."rental"
WHERE "end_date" IS NOT DISTINCT FROM '2026-11-13'
ORDER BY "rental_id"
LIMIT 20;
```

| rental_id | customer_id | vehicle_id | start_date | end_date | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | 2 | 2026-11-10 | 2026-11-13 | active | 166.5 |

## 3. Count payment records for each rental_id (up to 20 groups).

```sql
SELECT "rental_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "rental_id"
ORDER BY record_count DESC, "rental_id" NULLS LAST
LIMIT 20;
```

| rental_id | record_count |
| --- | --- |
| 3 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.154 | 1.147, 1.154, 1.174 | Sort → Seq Scan | 139 |
| After index | 0.188 | 0.186, 0.206, 0.188 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.154 ms to 0.188 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.119..1.121 rows=25 loops=1)
  Seq Scan on rental (actual time=0.014..1.085 rows=25 loops=1)
Planning Time: 0.313 ms
Execution Time: 1.147 ms
```

### Before index, run 2

```text
Sort (actual time=1.127..1.128 rows=25 loops=1)
  Seq Scan on rental (actual time=0.014..1.093 rows=25 loops=1)
Planning Time: 0.311 ms
Execution Time: 1.154 ms
```

### Before index, run 3

```text
Sort (actual time=1.147..1.149 rows=25 loops=1)
  Seq Scan on rental (actual time=0.039..1.112 rows=25 loops=1)
Planning Time: 0.324 ms
Execution Time: 1.174 ms
```

### After index, run 1

```text
Sort (actual time=0.142..0.144 rows=25 loops=1)
  Bitmap Heap Scan on rental (actual time=0.026..0.105 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=25 loops=1)
Planning Time: 0.552 ms
Execution Time: 0.186 ms
```

### After index, run 2

```text
Sort (actual time=0.164..0.166 rows=25 loops=1)
  Bitmap Heap Scan on rental (actual time=0.032..0.111 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=25 loops=1)
Planning Time: 0.518 ms
Execution Time: 0.206 ms
```

### After index, run 3

```text
Sort (actual time=0.143..0.145 rows=25 loops=1)
  Bitmap Heap Scan on rental (actual time=0.027..0.104 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.013 rows=25 loops=1)
Planning Time: 1.351 ms
Execution Time: 0.188 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Onabajo_Victor_301907272_P2_Queries.sql, then Onabajo_Victor_301907272_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Onabajo_Victor_301907272_P2_QueryResults.png) · [Index comparison](screenshots/Onabajo_Victor_301907272_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

