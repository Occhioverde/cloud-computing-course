# Step 5 — Analyse the results

## Add a year breakdown

Write a new script that includes the original aggregations plus a breakdown by year and category.

```
cat > /root/spark-lab/data/analysis2.py << 'ENDOFSCRIPT'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, round as _round, count

spark = SparkSession.builder.appName("SalesAnalysis2").master("spark://spark-master:7077").getOrCreate()
spark.sparkContext.setLogLevel("WARN")
df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

print("\n=== Revenue by category ===")
df.groupBy("category").agg(_sum("revenue").alias("total_revenue")).orderBy("total_revenue", ascending=False).show()

print("\n=== Revenue by region ===")
df.groupBy("region").agg(_sum("revenue").alias("total_revenue"), count("order_id").alias("orders")).orderBy("total_revenue", ascending=False).show()

print("\n=== Revenue by year and category ===")
df.groupBy("year", "category").agg(_sum("revenue").alias("total_revenue")).orderBy("year", "total_revenue", ascending=[True, False]).show()

spark.stop()
ENDOFSCRIPT
```{{exec}}

---

## Submit the new script

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/analysis2.py
```{{exec}}

---

## Interpret the output

The new table shows revenue split by year and category.

- Did Electronics revenue increase or decrease from 2023 to 2024?
- Did Furniture revenue increase or decrease?

---

## Check the Web UI

Refresh port 8080. You should now see **two completed applications**.
Each application is independent: a new SparkSession, new executor allocation,
new set of stages and tasks.
