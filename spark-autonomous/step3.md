# Task 3 — Filter and transform

## Objective

Write a new script `filter_transform.py` that:

1. Reads `logs.csv` and adds a column `is_error` that is `True` when `status_code >= 400`
2. Prints all error requests (status 4xx and 5xx) ordered by `response_ms` descending
3. Computes the average `response_ms` grouped by `endpoint`, ordered by average descending
4. Filters to only requests where `response_ms > 300` and prints them

## Available functions

```python
from pyspark.sql.functions import col, avg, round as _round, count, when

# Add a boolean column
df.withColumn("col_name", col("other_col") >= value)

# Filter with condition
df.filter(col("col") >= value)

# Filter with combined conditions
df.filter((col("a") >= x) & (col("b") == y))

# GroupBy and aggregate
df.groupBy("col").agg(avg("col2").alias("alias"))

# Order results
df.orderBy("col", ascending=False)

# Select specific columns
df.select("col1", "col2", "col3")
```

## Expected results

- Endpoint with highest average response time: `/api/checkout`
- Requests with `response_ms > 300`: includes the two 500 errors and some checkout requests

## Commands

Write your script to `/root/spark-lab/data/filter_transform.py`, then submit:

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/filter_transform.py
```
