# Step 4 — Querying the collection

MongoDB queries are JSON-like filter documents. Run each command below and observe the results.

**All sensors — no filter:**

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({}).toArray()'
```

**Active sensors only — equality filter:**

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ status: "active" }).toArray()'
```

**Battery above 70% — comparison operator `$gt` with projection:**

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ "specs.battery_pct": { $gt: 70 } }, { device_id: 1, "specs.battery_pct": 1, _id: 0 }).toArray()'
```

Dot-notation `"specs.battery_pct"` queries a field inside a nested object. The second argument is a projection: `1` includes the field, `0` excludes it.

**Temperature or humidity sensors — membership operator `$in`:**

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ type: { $in: ["temperature", "humidity"] } }).toArray()'
```

**Sensors tagged as "critical" — direct array element match:**

```bash
docker exec mongo mongosh sensor_registry --eval 'db.sensors.find({ tags: "critical" }).toArray()'
```

MongoDB searches inside arrays automatically: `{ tags: "critical" }` matches any document whose `tags` array contains the string `"critical"` — no special operator needed.
