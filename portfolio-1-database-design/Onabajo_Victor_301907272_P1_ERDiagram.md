# Vehicle Rental Management System — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text full_name
        text email UK
        text phone "Optional"
    }
    vehicle {
        bigint vehicle_id PK
        text plate UK
        text make
        text model
        numeric daily_rate
        boolean active
    }
    rental {
        bigint rental_id PK
        bigint customer_id FK
        bigint vehicle_id FK
        date start_date
        date end_date
        text status
        numeric total_amount
    }
    payment {
        bigint payment_id PK
        bigint rental_id FK
        numeric amount
        timestamptz paid_at
        text method
    }
    customer ||--o{ rental : "customer_id"
    vehicle ||--o{ rental : "vehicle_id"
    rental ||--o{ payment : "rental_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Onabajo_Victor_301907272_ERDiagram.png)
