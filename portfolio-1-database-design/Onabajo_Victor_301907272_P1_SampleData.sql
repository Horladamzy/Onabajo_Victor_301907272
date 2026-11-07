-- Fictional sample records for Vehicle Rental Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "phone") VALUES (1, 'Alex Morgan', 'alex.morgan@example.test', '+1-555-0101');
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model", "daily_rate", "active") VALUES (2, 'SYN-204', 'Toyota', 'Corolla', 55.5, TRUE);
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount") VALUES (3, 1, 2, '2026-11-10', '2026-11-13', 'active', 166.5);
INSERT INTO portfolio."payment" ("payment_id", "rental_id", "amount", "paid_at", "method") VALUES (4, 3, 166.5, '2026-11-10T09:30:00Z', 'card');
COMMIT;
