-- Vehicle Rental Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."vehicle" (
  "vehicle_id" bigint NOT NULL,
  "plate" text NOT NULL,
  "make" text NOT NULL,
  "model" text NOT NULL,
  "daily_rate" numeric(18,2) NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_vehicle" PRIMARY KEY ("vehicle_id"),
  CONSTRAINT "uq_vehicle_0" UNIQUE ("plate")
);
CREATE TABLE portfolio."rental" (
  "rental_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "vehicle_id" bigint NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "status" text NOT NULL,
  "total_amount" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_rental" PRIMARY KEY ("rental_id")
);
CREATE TABLE portfolio."payment" (
  "payment_id" bigint NOT NULL,
  "rental_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "paid_at" timestamptz NOT NULL,
  "method" text NOT NULL,
  CONSTRAINT "pk_payment" PRIMARY KEY ("payment_id")
);
ALTER TABLE portfolio."rental" ADD CONSTRAINT "fk_rental_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."rental" ADD CONSTRAINT "fk_rental_1" FOREIGN KEY ("vehicle_id") REFERENCES portfolio."vehicle" ("vehicle_id");
ALTER TABLE portfolio."payment" ADD CONSTRAINT "fk_payment_0" FOREIGN KEY ("rental_id") REFERENCES portfolio."rental" ("rental_id");
ALTER TABLE portfolio."rental" ADD CONSTRAINT "rental_dates_ordered" CHECK ("end_date" > "start_date");
CREATE UNIQUE INDEX "one_open_rental_per_vehicle" ON portfolio."rental" ("vehicle_id") WHERE (("status" = 'reserved') OR ("status" = 'active'));
COMMIT;
