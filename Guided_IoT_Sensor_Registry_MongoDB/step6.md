# Step 6 — Aggregation pipeline

The aggregation pipeline processes documents through a sequence of transformation stages. Build a pipeline that counts active sensors by type and computes the average battery level per type.

```bash
cat > /tmp/aggregate.js << 'EOF'
const result = db.sensors.aggregate([
  { $match: { status: "active" } },
  {
    $group: {
      _id: "$type",
      total: { $sum: 1 },
      avg_battery: { $avg: "$specs.battery_pct" }
    }
  },
  { $sort: { total: -1 } }
]).toArray()
printjson(result)
EOF
```

```bash
docker cp /tmp/aggregate.js mongo:/tmp/aggregate.js
```

```bash
docker exec mongo mongosh sensor_registry /tmp/aggregate.js
```

The pipeline executes in order:
- `$match` keeps only active sensors, excluding SNS-004 which is in maintenance
- `$group` groups documents by `type`, counting how many and averaging `specs.battery_pct`
- `$sort` orders the output by `total` descending

Expected output: two groups — `temperature` (3 sensors) and `humidity` (2 sensors). The pressure sensor is excluded by `$match` and therefore produces no group.
