# Step 2 — Inserting the first sensor document

Create a JavaScript file with the first document. Notice the nested `location` and `specs` objects and the `tags` array — this is the document model in action.

```bash
cat > /tmp/insert_one.js << 'EOF'
printjson(db.sensors.insertOne({
  device_id: "SNS-001",
  name: "Temperature Sensor Alpha",
  type: "temperature",
  location: { building: "A", floor: 2, room: "Lab-201" },
  specs: { firmware: "v2.1.0", battery_pct: 87, sampling_rate_s: 30 },
  tags: ["outdoor", "critical"],
  status: "active"
}))
EOF
```

Copy the file into the container and execute it:

```bash
docker cp /tmp/insert_one.js mongo:/tmp/insert_one.js
```

```bash
docker exec mongo mongosh sensor_registry /tmp/insert_one.js
```

The output shows `acknowledged: true` and the auto-generated `_id`. Retrieve the document to verify the nested structure:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-001" })'
```

MongoDB created the `sensor_registry` database automatically on the first write — no `CREATE DATABASE` statement is needed.
