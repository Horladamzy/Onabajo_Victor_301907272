# Vehicle Rental Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | rental records (list) |
| --- | --- |
| 1 | [3] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| rental.rental_id | rental.customer_id | rental.vehicle_id | rental.status | customer.customer_id | customer.full_name | vehicle.vehicle_id | vehicle.plate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | 2 | active | 1 | Alex Morgan | 2 | SYN-204 |

Key: rental_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## rental_example

| rental.rental_id | rental.customer_id | rental.vehicle_id | rental.status | customer.customer_id | customer.full_name | vehicle.vehicle_id | vehicle.plate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | 2 | active | 1 | Alex Morgan | 2 | SYN-204 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | full_name | email | phone |
| --- | --- | --- | --- |
| 1 | Alex Morgan | alex.morgan@example.test | +1-555-0101 |

## vehicle

| vehicle_id | plate | make | model | daily_rate | active |
| --- | --- | --- | --- | --- | --- |
| 2 | SYN-204 | Toyota | Corolla | 55.5 | true |

## rental

| rental_id | customer_id | vehicle_id | start_date | end_date | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | 2 | 2026-11-10 | 2026-11-13 | active | 166.5 |

## payment

| payment_id | rental_id | amount | paid_at | method |
| --- | --- | --- | --- | --- |
| 4 | 3 | 166.5 | 2026-11-10T09:30:00+00:00 | card |

## Dependencies

- customer: (customer_id) → full_name, email, phone
- vehicle: (vehicle_id) → plate, make, model, daily_rate, active
- rental: (rental_id) → customer_id, vehicle_id, start_date, end_date, status, total_amount
- payment: (payment_id) → rental_id, amount, paid_at, method

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
