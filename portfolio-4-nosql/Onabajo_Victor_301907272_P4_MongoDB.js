// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("rental_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("rental_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "rental_created",
                    "rental_checked_out"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "payment"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "payment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("rental_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "rental_created",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 4
            },
            "snapshot": {
                "payment_id": 4,
                "rental_id": 3,
                "amount": 166.5,
                "paid_at": "2026-11-10T09:30:00Z",
                "method": "card"
            }
        },
        "embedded": {
            "customer": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Alex Morgan",
                        "email": "alex.morgan@example.test",
                        "phone": "+1-555-0101"
                    },
                    "via": [
                        "payment.rental_id → rental.customer_id → customer"
                    ]
                }
            ],
            "vehicle": [
                {
                    "key": {
                        "vehicle_id": 2
                    },
                    "snapshot": {
                        "vehicle_id": 2,
                        "plate": "SYN-204",
                        "make": "Toyota",
                        "model": "Corolla",
                        "daily_rate": 55.5,
                        "active": true
                    },
                    "via": [
                        "payment.rental_id → rental.vehicle_id → vehicle"
                    ]
                }
            ]
        },
        "references": {
            "rental": [
                {
                    "key": {
                        "rental_id": 3
                    },
                    "via": [
                        "payment.rental_id → rental"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "rental_checked_out",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "payment",
            "key": {
                "payment_id": 4
            },
            "snapshot": {
                "payment_id": 4,
                "rental_id": 3,
                "amount": 166.5,
                "paid_at": "2026-11-10T09:30:00Z",
                "method": "card"
            }
        },
        "embedded": {
            "customer": [
                {
                    "key": {
                        "customer_id": 1
                    },
                    "snapshot": {
                        "customer_id": 1,
                        "full_name": "Alex Morgan",
                        "email": "alex.morgan@example.test",
                        "phone": "+1-555-0101"
                    },
                    "via": [
                        "payment.rental_id → rental.customer_id → customer"
                    ]
                }
            ],
            "vehicle": [
                {
                    "key": {
                        "vehicle_id": 2
                    },
                    "snapshot": {
                        "vehicle_id": 2,
                        "plate": "SYN-204",
                        "make": "Toyota",
                        "model": "Corolla",
                        "daily_rate": 55.5,
                        "active": true
                    },
                    "via": [
                        "payment.rental_id → rental.vehicle_id → vehicle"
                    ]
                }
            ]
        },
        "references": {
            "rental": [
                {
                    "key": {
                        "rental_id": 3
                    },
                    "via": [
                        "payment.rental_id → rental"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "damage_notes": "illustrative damage_notes",
                "inspection_photos": "illustrative inspection_photos",
                "payment_reference": "illustrative payment_reference"
            }
        }
    }
]));
  await db.getCollection("rental_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("rental_events").find({"eventType":"rental_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("rental_events").find({"source.key.payment_id":4}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("rental_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("rental_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("rental_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "rental_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payment",
        "key": {
            "payment_id": 4
        },
        "snapshot": {
            "payment_id": 4,
            "rental_id": 3,
            "amount": 166.5,
            "paid_at": "2026-11-10T09:30:00Z",
            "method": "card"
        }
    },
    "embedded": {
        "customer": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "full_name": "Alex Morgan",
                    "email": "alex.morgan@example.test",
                    "phone": "+1-555-0101"
                },
                "via": [
                    "payment.rental_id → rental.customer_id → customer"
                ]
            }
        ],
        "vehicle": [
            {
                "key": {
                    "vehicle_id": 2
                },
                "snapshot": {
                    "vehicle_id": 2,
                    "plate": "SYN-204",
                    "make": "Toyota",
                    "model": "Corolla",
                    "daily_rate": 55.5,
                    "active": true
                },
                "via": [
                    "payment.rental_id → rental.vehicle_id → vehicle"
                ]
            }
        ]
    },
    "references": {
        "rental": [
            {
                "key": {
                    "rental_id": 3
                },
                "via": [
                    "payment.rental_id → rental"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("rental_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "rental_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payment",
        "key": {
            "payment_id": 4
        },
        "snapshot": {
            "payment_id": 4,
            "rental_id": 3,
            "amount": 166.5,
            "paid_at": "2026-11-10T09:30:00Z",
            "method": "card"
        }
    },
    "embedded": {
        "customer": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "full_name": "Alex Morgan",
                    "email": "alex.morgan@example.test",
                    "phone": "+1-555-0101"
                },
                "via": [
                    "payment.rental_id → rental.customer_id → customer"
                ]
            }
        ],
        "vehicle": [
            {
                "key": {
                    "vehicle_id": 2
                },
                "snapshot": {
                    "vehicle_id": 2,
                    "plate": "SYN-204",
                    "make": "Toyota",
                    "model": "Corolla",
                    "daily_rate": 55.5,
                    "active": true
                },
                "via": [
                    "payment.rental_id → rental.vehicle_id → vehicle"
                ]
            }
        ]
    },
    "references": {
        "rental": [
            {
                "key": {
                    "rental_id": 3
                },
                "via": [
                    "payment.rental_id → rental"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("rental_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
