# Exercise complete

You have built a complete IoT sensor registry in MongoDB:

- Created the `sensor_registry` database and the `sensors` collection
- Inserted documents with nested `location` and `specs` objects and a `tags` array
- Queried the collection using equality filters, dot-notation on nested fields, comparison operators, and direct array element matching
- Updated a single document with `$set` and multiple documents with `$push`
- Aggregated sensor counts and average battery levels by type using a three-stage pipeline
- Deleted a decommissioned sensor and verified the final state

These operations form the core of any MongoDB-backed application.
