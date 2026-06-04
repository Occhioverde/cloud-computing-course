# Task 6 — Spark SQL

## Objective

Write a script `spark_sql.py` that:

1. Reads `logs.csv` and `users.csv`, joins them, and registers the result
   as a temporary view called `requests`
2. Using `spark.sql()`, answers these three questions:
   - How many requests per endpoint, ordered by count descending?
   - What is the average response time per country, ordered by average descending?
   - Which user made the most requests, and how many?

## Available functions

```python
df.createOrReplaceTempView("view_name")

spark.sql("""
    SELECT col1, COUNT(*) AS cnt
    FROM view_name
    GROUP BY col1
    ORDER BY cnt DESC
""").show()
```

## Expected results

- `/api/products` should have the most requests
- Average response time per country will vary
- User `u001` or `u003` should be among the most active

## Final check

Refresh the Web UI. You should see **at least 5 completed applications** in total
across both tasks in this exercise session.

## Commands

Write your script to `/root/spark-lab/data/spark_sql.py`, then submit:

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/spark_sql.py
```
