# Step 2 — Inserting the first sensor document

The file `/root/insert_one.js` was created during setup. It inserts a document with a nested `location` object, a nested `specs` object, and a `tags` array:

```javascript
printjson(db.sensors.insertOne({
  device_id: "SNS-001",
  name: "Temperature Sensor Alpha",
  type: "temperature",
  location: { building: "A", floor: 2, room: "Lab-201" },
  specs: { firmware: "v2.1.0", battery_pct: 87, sampling_rate_s: 30 },
  tags: ["outdoor", "critical"],
  status: "active"
}))
```

Copy the file into the container:

```
docker cp /root/insert_one.js mongo:/tmp/insert_one.js
```

Execute the script:

```
docker exec mongo mongosh sensor_registry /tmp/insert_one.js
```

The output shows `acknowledged: true` and the auto-generated `_id`. Retrieve the document to verify the nested structure:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-001" })'
```

MongoDB created the `sensor_registry` database automatically on the first write — no `CREATE DATABASE` needed.
