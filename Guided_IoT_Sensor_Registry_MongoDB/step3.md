# Step 3 — Populating the sensor fleet

Insert five more sensors with `insertMany`. The dataset covers three device types across three buildings with varying battery levels and statuses.

```bash
cat > /tmp/insert_many.js << 'EOF'
printjson(db.sensors.insertMany([
  {
    device_id: "SNS-002", name: "Humidity Sensor Beta", type: "humidity",
    location: { building: "A", floor: 2, room: "Lab-202" },
    specs: { firmware: "v1.8.0", battery_pct: 45, sampling_rate_s: 60 },
    tags: ["indoor"], status: "active"
  },
  {
    device_id: "SNS-003", name: "Temperature Sensor Gamma", type: "temperature",
    location: { building: "B", floor: 1, room: "Server-101" },
    specs: { firmware: "v2.1.0", battery_pct: 92, sampling_rate_s: 30 },
    tags: ["outdoor", "weatherproof"], status: "active"
  },
  {
    device_id: "SNS-004", name: "Pressure Sensor Delta", type: "pressure",
    location: { building: "B", floor: 3, room: "Roof-301" },
    specs: { firmware: "v1.5.0", battery_pct: 12, sampling_rate_s: 120 },
    tags: ["critical"], status: "maintenance"
  },
  {
    device_id: "SNS-005", name: "Temperature Sensor Epsilon", type: "temperature",
    location: { building: "C", floor: 1, room: "Entrance-101" },
    specs: { firmware: "v2.0.0", battery_pct: 78, sampling_rate_s: 30 },
    tags: ["outdoor", "weatherproof"], status: "active"
  },
  {
    device_id: "SNS-006", name: "Humidity Sensor Zeta", type: "humidity",
    location: { building: "C", floor: 2, room: "Storage-201" },
    specs: { firmware: "v1.8.0", battery_pct: 61, sampling_rate_s: 60 },
    tags: ["indoor"], status: "active"
  }
]))
EOF
```

```bash
docker cp /tmp/insert_many.js mongo:/tmp/insert_many.js
```

```bash
docker exec mongo mongosh sensor_registry /tmp/insert_many.js
```

Confirm the total document count:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.countDocuments()'
```

Expected result: `6`.
