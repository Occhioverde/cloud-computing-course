# Step 6 — Filter and transform

## Create a new script

You will write a new script that filters and transforms the data.

```
cat > /root/spark-lab/filter_transform.py << 'PYEOF'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, round as _round

spark = SparkSession.builder \
    .appName("FilterTransform") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

# Filter: only Electronics orders from 2024
electronics_2024 = df.filter((col("category") == "Electronics") & (col("year") == 2024))

print("\n=== Electronics orders in 2024 ===")
electronics_2024.show()

print("\n=== Count ===")
print(electronics_2024.count())

# Add a discount column: 10% discount on orders with quantity > 10
df_discounted = df.withColumn(
    "discounted_revenue",
    _round(
        col("revenue") * col("quantity").cast("double").between(10, 9999).cast("double") * 0.9
        + col("revenue") * (col("quantity") < 10).cast("double"),
        2
    )
)

print("\n=== High-volume orders with 10% discount applied ===")
df_discounted.filter(col("quantity") >= 10).select(
    "product", "quantity", "revenue", "discounted_revenue"
).orderBy("quantity", ascending=False).show()

spark.stop()
PYEOF
```{{exec}}

---

## Copy and submit

```
docker cp /root/spark-lab/filter_transform.py spark-master:/data/filter_transform.py
```{{exec}}

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/filter_transform.py
```{{exec}}

---

## What to observe

**Electronics orders in 2024** — the `filter()` call uses two conditions combined with `&`.
Both conditions must be true for a row to be included.

**High-volume orders** — the `withColumn()` call adds a new column computed from existing ones.
The `filter()` after it is a lazy transformation — it adds to the DAG but does not trigger execution.
Only `show()` triggers the actual computation.
