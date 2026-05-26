# Step 7 — Deleting documents and final check

Sensor SNS-004 has been physically decommissioned. Remove it from the registry:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.deleteOne({ device_id: "SNS-004" })'
```

Confirm the deletion — the result should be `null`:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.findOne({ device_id: "SNS-004" })'
```

Verify the final document count:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.countDocuments()'
```

Expected: `5`.

Confirm no sensor remains in maintenance status:

```
docker exec mongo mongosh sensor_registry --eval 'db.sensors.countDocuments({ status: "maintenance" })'
```

Expected: `0`.
