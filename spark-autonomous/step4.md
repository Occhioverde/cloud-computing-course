# Task 4 — Join two DataFrames

## Objective

Write a script `join_analysis.py` that:

1. Reads both `logs.csv` and `users.csv`
2. Joins them on `user_id` (inner join)
3. Computes the request count grouped by `plan` (free vs premium)
4. Computes the average `response_ms` grouped by `country`
5. Finds which country has the highest proportion of error requests (status >= 400)

## Available functions

```python
# Read a second CSV
users = spark.read.csv("/data/users.csv", header=True, inferSchema=True)

# Inner join
enriched = df.join(users, on="user_id", how="inner")

# GroupBy with multiple aggregations
df.groupBy("col").agg(
    count("col2").alias("alias1"),
    avg("col3").alias("alias2")
)

# Filter before aggregation
df.filter(col("status_code") >= 400)
```

## Expected results

- Premium users make fewer requests than free users (check the counts)
- Average response time varies by country
- Italy has the most error requests in absolute terms (u001 accounts for multiple 500 errors)

## Commands

Write your script to `/root/spark-lab/data/join_analysis.py`, then submit:

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/join_analysis.py
```
