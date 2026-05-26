# Step 6 — Aggregation pipeline

The file `/root/aggregate.js` contains a three-stage pipeline that counts active sensors by type and computes the average battery level:

```javascript
const result = db.sensors.aggregate([
  { $match: { status: "active" } },
  { $group: { _id: "$type", total: { $sum: 1 }, avg_battery: { $avg: "$specs.battery_pct" } } },
  { $sort: { total: -1 } }
]).toArray()
printjson(result)
```

Copy the file into the container:

```
docker cp /root/aggregate.js mongo:/tmp/aggregate.js
```

Execute the pipeline:

```
docker exec mongo mongosh sensor_registry /tmp/aggregate.js
```

The pipeline executes in order:
- `$match` keeps only active sensors — SNS-004 (maintenance) is excluded
- `$group` groups by `type`, counting sensors and averaging `specs.battery_pct`
- `$sort` orders by `total` descending

Expected output: two groups — `temperature` (3 sensors) and `humidity` (2 sensors).
