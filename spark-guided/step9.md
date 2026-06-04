# Step 9 — Spark SQL

## Create the SQL script

So far you have used the DataFrame API. Spark also supports standard SQL syntax
via `spark.sql()`. The Catalyst optimizer produces the same execution plan
regardless of which interface you use.

```
cat > /root/spark-lab/data/spark_sql.py << 'ENDOFSCRIPT'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, round as _round

spark = SparkSession.builder.appName("SparkSQL").master("spark://spark-master:7077").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

df.createOrReplaceTempView("sales")

print("\n=== Revenue by category (SQL) ===")
spark.sql("SELECT category, ROUND(SUM(revenue), 2) AS total_revenue FROM sales GROUP BY category ORDER BY total_revenue DESC").show()

print("\n=== Top 3 products by revenue (SQL) ===")
spark.sql("SELECT product, SUM(quantity) AS total_units, ROUND(SUM(revenue), 2) AS total_revenue FROM sales GROUP BY product ORDER BY total_revenue DESC LIMIT 3").show()

print("\n=== Premium orders in 2024 (SQL) ===")
spark.sql("SELECT order_id, product, region, unit_price, revenue FROM sales WHERE unit_price > 200 AND year = 2024 ORDER BY unit_price DESC").show()

spark.stop()
ENDOFSCRIPT
```{{exec}}

---

## Submit

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/spark_sql.py
```{{exec}}

---

## What to observe

**`createOrReplaceTempView("sales")`** registers the DataFrame under a name
that SQL queries can reference. The view is local to this SparkSession
and disappears when `spark.stop()` is called.

**`spark.sql("...")`** accepts any standard SQL string and returns a DataFrame.
The result is lazy — the query is not executed until `.show()` or another action is called.

**Same optimizer** — the execution plan for `spark.sql("SELECT ... GROUP BY ...")` is identical
to what Catalyst would generate from `df.groupBy().agg()`.
Both paths go through the same four-phase optimization pipeline.
