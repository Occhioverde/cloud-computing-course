# Step 5 — Updating documents

**`updateOne` with `$set` — update a single document:**

Sensor SNS-001 has received a firmware upgrade:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.updateOne({ device_id: "SNS-001" }, { $set: { "specs.firmware": "v2.2.0" } })'
```

Verify the change:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-001" }, { device_id: 1, "specs.firmware": 1, _id: 0 })'
```

**`updateMany` with `$push` — append a tag to multiple documents:**

All building A sensors have passed a compliance audit:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.updateMany({ "location.building": "A" }, { $push: { tags: "audited" } })'
```

Verify that both building A sensors now include the new tag:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ "location.building": "A" }, { device_id: 1, tags: 1, _id: 0 }).toArray()'
```

`$set` replaces or creates a specific field. `$push` appends an element to an existing array.
