-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk duplicate. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "phone")
VALUES (1, 'Casey Reed', 'casey.reed@example.test', '+1-555-0102');

-- 2. customer email duplicate. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "phone")
VALUES (101, 'Casey Reed', 'alex.morgan@example.test', '+1-555-0102');

-- 3. customer name null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "phone")
VALUES (102, NULL, 'casey.reed@example.test', '+1-555-0102');

-- 4. vehicle pk duplicate. Expected: pk_vehicle, SQLSTATE 23505.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model", "daily_rate", "active")
VALUES (2, 'SYN-305', 'Honda', 'Civic', 48, TRUE);

-- 5. vehicle plate duplicate. Expected: uq_vehicle_0, SQLSTATE 23505.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model", "daily_rate", "active")
VALUES (103, 'SYN-204', 'Honda', 'Civic', 48, TRUE);

-- 6. rental pk duplicate. Expected: pk_rental, SQLSTATE 23505.
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount")
VALUES (3, 1, 2, '2026-11-15', '2026-11-16', 'completed', 55.5);

-- 7. rental customer fk missing. Expected: fk_rental_0, SQLSTATE 23503.
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount")
VALUES (104, 999, 2, '2026-11-15', '2026-11-16', 'completed', 55.5);

-- 8. rental vehicle fk missing. Expected: fk_rental_1, SQLSTATE 23503.
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount")
VALUES (105, 1, 999, '2026-11-15', '2026-11-16', 'completed', 55.5);

-- 9. rental dates invalid. Expected: rental_dates_ordered, SQLSTATE 23514.
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount")
VALUES (106, 1, 2, '2026-11-16', '2026-11-15', 'completed', 55.5);

-- 10. rental open vehicle duplicate. Expected: one_open_rental_per_vehicle, SQLSTATE 23505.
INSERT INTO portfolio."rental" ("rental_id", "customer_id", "vehicle_id", "start_date", "end_date", "status", "total_amount")
VALUES (107, 1, 2, '2026-11-15', '2026-11-16', 'reserved', 55.5);

-- 11. payment pk duplicate. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "rental_id", "amount", "paid_at", "method")
VALUES (4, 3, 25, '2026-11-11T10:00:00Z', 'cash');

-- 12. payment rental fk missing. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "rental_id", "amount", "paid_at", "method")
VALUES (108, 999, 25, '2026-11-11T10:00:00Z', 'cash');
