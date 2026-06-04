# Step 6 — Filter and transform

## Create a new script

```
cat > /root/spark-lab/data/filter_transform.py << 'ENDOFSCRIPT'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, round as _round, when

spark = SparkSession.builder.appName("FilterTransform").master("spark://spark-master:7077").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

electronics_2024 = df.filter((col("category") == "Electronics") & (col("year") == 2024))

print("\n=== Electronics orders in 2024 ===")
electronics_2024.show()

print("\n=== Count ===")
print(electronics_2024.count())

df_discounted = df.withColumn(
    "discounted_revenue",
    _round(when(col("quantity") >= 10, col("revenue") * 0.9).otherwise(col("revenue")), 2)
)

print("\n=== High-volume orders with 10% discount applied ===")
df_discounted.filter(col("quantity") >= 10).select("product", "quantity", "revenue", "discounted_revenue").orderBy("quantity", ascending=False).show()

spark.stop()
ENDOFSCRIPT
```{{exec}}

---

## Submit

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/filter_transform.py
```{{exec}}

---

## What to observe

**Electronics orders in 2024** — the `filter()` call uses two conditions combined with `&`.
Both conditions must be true for a row to be included.

**Discounted revenue** — `when(...).otherwise(...)` is the PySpark equivalent of an if-else
applied column by column. Only `show()` triggers the actual computation — all prior
`withColumn()` and `filter()` calls are lazy transformations recorded in the DAG.
