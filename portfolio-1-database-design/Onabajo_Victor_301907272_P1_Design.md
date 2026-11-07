# Vehicle Rental Management System — database design

My case study records customer, vehicle, rental, payment.

## Users

- Rental staff
- Service managers

## Main operations

- Register customers and vehicles
- Create and update rentals
- Record rental payments
- Review rental activity and revenue

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person who rents vehicles. |
| vehicle | A vehicle available for rental. |
| rental | A dated reservation or rental linking one customer to one vehicle. |
| payment | A payment recorded against a rental. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| phone | TEXT |  | No |
- Unique key: (email).

## vehicle

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| vehicle_id | BIGINT | PK | Yes |
| plate | TEXT | Unique | Yes |
| make | TEXT |  | Yes |
| model | TEXT |  | Yes |
| daily_rate | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (plate).

## rental

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| rental_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| vehicle_id | BIGINT | FK | Yes |
| start_date | DATE |  | Yes |
| end_date | DATE |  | Yes |
| status | TEXT |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
- customer_id → customer.customer_id
- vehicle_id → vehicle.vehicle_id

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| rental_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| paid_at | TIMESTAMPTZ |  | Yes |
| method | TEXT |  | Yes |
- rental_id → rental.rental_id

## Relationships and business rules

- Each customer email identifies at most one customer.
- Each vehicle plate identifies at most one vehicle.
- Every rental must reference an existing customer through customer_id.
- Every rental must reference an existing vehicle through vehicle_id.
- A rental's end_date must be later than its start_date.
- A vehicle may have at most one rental with reserved or active status; enforce a partial unique constraint on vehicle_id for those statuses.
- Every payment must reference an existing rental through rental_id.

## Assumptions

- Rental start and end dates are calendar dates, and the end date must be later than the start date.
- A rental's total_amount records its agreed charge; taxes, deposits, late fees, and partial payments are outside this exercise.
- Worked normalisation example rooted at Rental: an initial rental record repeats the customer's full_name alongside customer_id. Move full_name to Customer and retain customer_id in Rental as a foreign key. This removes the customer-name update anomaly while representing the customer role once.
- Separate benchmark plan: create 25,000 synthetic Rental rows, compare the same end_date filter with and without a B-tree index, and record query plans and elapsed time under the same conditions. The row count is a test setup, not a claim about measured performance.
- All records and benchmark inputs are synthetic.

