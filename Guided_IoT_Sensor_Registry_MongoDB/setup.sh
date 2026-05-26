#!/bin/bash
docker pull mongo:7 > /dev/null 2>&1

cat > /root/insert_one.js << 'EOF'
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

cat > /root/insert_many.js << 'EOF'
printjson(db.sensors.insertMany([
  { device_id: "SNS-002", name: "Humidity Sensor Beta", type: "humidity",
    location: { building: "A", floor: 2, room: "Lab-202" },
    specs: { firmware: "v1.8.0", battery_pct: 45, sampling_rate_s: 60 },
    tags: ["indoor"], status: "active" },
  { device_id: "SNS-003", name: "Temperature Sensor Gamma", type: "temperature",
    location: { building: "B", floor: 1, room: "Server-101" },
    specs: { firmware: "v2.1.0", battery_pct: 92, sampling_rate_s: 30 },
    tags: ["outdoor", "weatherproof"], status: "active" },
  { device_id: "SNS-004", name: "Pressure Sensor Delta", type: "pressure",
    location: { building: "B", floor: 3, room: "Roof-301" },
    specs: { firmware: "v1.5.0", battery_pct: 12, sampling_rate_s: 120 },
    tags: ["critical"], status: "maintenance" },
  { device_id: "SNS-005", name: "Temperature Sensor Epsilon", type: "temperature",
    location: { building: "C", floor: 1, room: "Entrance-101" },
    specs: { firmware: "v2.0.0", battery_pct: 78, sampling_rate_s: 30 },
    tags: ["outdoor", "weatherproof"], status: "active" },
  { device_id: "SNS-006", name: "Humidity Sensor Zeta", type: "humidity",
    location: { building: "C", floor: 2, room: "Storage-201" },
    specs: { firmware: "v1.8.0", battery_pct: 61, sampling_rate_s: 60 },
    tags: ["indoor"], status: "active" }
]))
EOF

cat > /root/aggregate.js << 'EOF'
const result = db.sensors.aggregate([
  { $match: { status: "active" } },
  { $group: { _id: "$type", total: { $sum: 1 }, avg_battery: { $avg: "$specs.battery_pct" } } },
  { $sort: { total: -1 } }
]).toArray()
printjson(result)
EOF

echo "Ready"
