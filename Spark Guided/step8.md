# Step 8 — Cache and reuse

## Create the cache script

```
cat > /root/spark-lab/cache_demo.py << 'PYEOF'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, count, round as _round
import time

spark = SparkSession.builder \
    .appName("CacheDemo") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

# --- WITHOUT CACHE ---
print("\n=== Without cache: running two aggregations ===")
t0 = time.time()

df.groupBy("category").agg(_sum("revenue").alias("total_revenue")).show()
df.groupBy("region").agg(count("order_id").alias("orders")).show()

t1 = time.time()
print(f"Time without cache: {t1 - t0:.2f} seconds")

# --- WITH CACHE ---
print("\n=== With cache: caching the DataFrame first ===")
df.cache()
df.count()  # materialise the cache

t2 = time.time()

df.groupBy("category").agg(_sum("revenue").alias("total_revenue")).show()
df.groupBy("region").agg(count("order_id").alias("orders")).show()

t3 = time.time()
print(f"Time with cache: {t3 - t2:.2f} seconds")

print("\nNote: on a 20-row dataset the difference is minimal.")
print("On millions of rows the cached version avoids re-reading from disk entirely.")

df.unpersist()
spark.stop()
PYEOF
```{{exec}}

---

## Copy and submit

```
docker cp /root/spark-lab/cache_demo.py spark-master:/data/cache_demo.py
```{{exec}}

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/cache_demo.py
```{{exec}}

---

## What to observe

**`df.cache()`** marks the DataFrame to be stored in executor memory after first computation.
The `df.count()` call immediately after it forces materialisation —
without it, the cache would only fill lazily when the next action is called.

**`df.unpersist()`** releases the cached data from executor memory explicitly.
If you omit it, Spark eventually evicts it automatically when memory is needed.

**The timing difference** on 20 rows is negligible.
On a real dataset of millions of rows, re-reading from HDFS or S3 on every action
would cost seconds or minutes — caching eliminates that I/O entirely for subsequent queries.

**In the Web UI** — refresh port 8080 and open the **CacheDemo** application.
You will see that the second pair of aggregations produced fewer read bytes
in their stages compared to the first pair.
