# Step 5 — Updating documents

**Update a single document — `updateOne` with `$set`:**

Sensor SNS-001 has received a firmware upgrade. Update its `specs.firmware` field:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.updateOne({ device_id: "SNS-001" }, { $set: { "specs.firmware": "v2.2.0" } })'
```

Verify the change:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-001" }, { device_id: 1, "specs.firmware": 1, _id: 0 })'
```

**Update multiple documents — `updateMany` with `$push`:**

All sensors in building A have passed a compliance audit. Add the tag `"audited"` to their `tags` array:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.updateMany({ "location.building": "A" }, { $push: { tags: "audited" } })'
```

Verify that both building A sensors now carry the new tag:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ "location.building": "A" }, { device_id: 1, tags: 1, _id: 0 }).toArray()'
```

`$set` replaces or creates a specific field. `$push` appends an element to an existing array without overwriting the other elements.
