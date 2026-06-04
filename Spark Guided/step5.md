# Step 5 — Analyse the results

## Add a year breakdown

You will now add a third aggregation to the script: revenue broken down by year and category.

```
cat >> /root/spark-lab/analysis.py << 'PYEOF'

print("\n=== Revenue by year and category ===")
df.groupBy("year", "category") \
  .agg(_sum("revenue").alias("total_revenue")) \
  .orderBy("year", "total_revenue", ascending=[True, False]) \
  .show()
PYEOF
```{{exec}}

---

## Copy the updated script and resubmit

```
docker cp /root/spark-lab/analysis.py spark-master:/data/analysis.py
```{{exec}}

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/analysis.py
```{{exec}}

---

## Interpret the new output

The new table shows revenue split by year and category.

- Did Electronics revenue increase or decrease from 2023 to 2024?
- Did Furniture revenue increase or decrease?

---

## Check the Web UI

Refresh port 8080. You should now see **two completed applications**.
Each application is independent: a new SparkSession, new executor allocation,
new set of stages and tasks.
