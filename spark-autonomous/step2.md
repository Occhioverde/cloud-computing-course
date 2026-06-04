# Task 2 — Submit the baseline job

## Objective

Run the baseline script `/data/baseline.py` against the cluster.
Verify the schema, the sample rows, and the request count by status code.

## Note
Write scripts to `/root/spark-lab/data/` — they are immediately available at `/data/` inside the container via volume mount. No `docker cp` needed.

## Available commands

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/baseline.py
```

## Expected output

- Total requests: **25**
- Status code 200 is the most frequent
- Status codes present: 200, 201, 401, 404, 500

## What to check in the Web UI

After the job completes, open the **LogBaseline** application in the Web UI.
How many stages did this job produce?
How does it compare to the aggregation jobs from Exercise A?
