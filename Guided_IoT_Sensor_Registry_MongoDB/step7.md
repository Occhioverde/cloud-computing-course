# Step 7 — Deleting documents and final check

Sensor SNS-004 (pressure, building B, maintenance status) has been physically decommissioned. Remove it from the registry:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.deleteOne({ device_id: "SNS-004" })'
```

Confirm the deletion — the query should return `null`:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-004" })'
```

Verify the final document count:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.countDocuments()'
```

Expected: `5`.

Confirm that no sensor remains in maintenance status:

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.countDocuments({ status: "maintenance" })'
```

Expected: `0`.
