# Step 9 — Spark SQL

## Create the SQL script

So far you have used the DataFrame API. Spark also supports standard SQL syntax
via `spark.sql()`. The query optimizer (Catalyst) produces the same execution plan
regardless of which interface you use.

```
cat > /root/spark-lab/spark_sql.py << 'PYEOF'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, round as _round

spark = SparkSession.builder \
    .appName("SparkSQL") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

# Register the DataFrame as a temporary SQL view
df.createOrReplaceTempView("sales")

# Query 1: revenue by category using SQL
print("\n=== Revenue by category (SQL) ===")
spark.sql("""
    SELECT category,
           ROUND(SUM(revenue), 2) AS total_revenue
    FROM sales
    GROUP BY category
    ORDER BY total_revenue DESC
""").show()

# Query 2: top 3 products by total revenue
print("\n=== Top 3 products by revenue (SQL) ===")
spark.sql("""
    SELECT product,
           SUM(quantity) AS total_units,
           ROUND(SUM(revenue), 2) AS total_revenue
    FROM sales
    GROUP BY product
    ORDER BY total_revenue DESC
    LIMIT 3
""").show()

# Query 3: orders where unit_price > 200 and year = 2024
print("\n=== Premium orders in 2024 (SQL) ===")
spark.sql("""
    SELECT order_id, product, region, unit_price, revenue
    FROM sales
    WHERE unit_price > 200 AND year = 2024
    ORDER BY unit_price DESC
""").show()

spark.stop()
PYEOF
```{{exec}}

---

## Copy and submit

```
docker cp /root/spark-lab/spark_sql.py spark-master:/data/spark_sql.py
```{{exec}}

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/spark_sql.py
```{{exec}}

---

## What to observe

**`createOrReplaceTempView("sales")`** registers the DataFrame under a name
that SQL queries can reference. The view is local to this SparkSession and disappears when `spark.stop()` is called.

**`spark.sql("""...""")`** accepts any standard SQL string and returns a DataFrame.
The result is lazy — the query is not executed until `.show()` or another action is called.

**Same optimizer** — the execution plan for `spark.sql("SELECT ... GROUP BY ...")` is identical
to what Catalyst would generate from `df.groupBy().agg()`.
Both paths go through the same four-phase optimization pipeline.
