# Step 8 — Cache and reuse

## Create the cache script

```
cat > /root/spark-lab/data/cache_demo.py << 'ENDOFSCRIPT'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, count, round as _round
import time

spark = SparkSession.builder.appName("CacheDemo").master("spark://spark-master:7077").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

print("\n=== Without cache: running two aggregations ===")
t0 = time.time()
df.groupBy("category").agg(_sum("revenue").alias("total_revenue")).show()
df.groupBy("region").agg(count("order_id").alias("orders")).show()
t1 = time.time()
print(f"Time without cache: {t1 - t0:.2f} seconds")

print("\n=== With cache: caching the DataFrame first ===")
df.cache()
df.count()
t2 = time.time()
df.groupBy("category").agg(_sum("revenue").alias("total_revenue")).show()
df.groupBy("region").agg(count("order_id").alias("orders")).show()
t3 = time.time()
print(f"Time with cache: {t3 - t2:.2f} seconds")

print("\nNote: on a 20-row dataset the difference is minimal.")
print("On millions of rows the cached version avoids re-reading from disk entirely.")

df.unpersist()
spark.stop()
ENDOFSCRIPT
```{{exec}}

---

## Submit

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/cache_demo.py
```{{exec}}

---

## What to observe

**`df.cache()`** marks the DataFrame to be stored in executor memory after first computation.
The `df.count()` call immediately after forces materialisation —
without it, the cache fills lazily only when the next action is called.

**`df.unpersist()`** releases the cached data explicitly.
If omitted, Spark evicts it automatically when memory is needed.

**The timing difference** on 20 rows is negligible.
On a real dataset of millions of rows, caching eliminates repeated disk reads entirely.

**In the Web UI** — open the **CacheDemo** application.
The second pair of aggregations should show fewer input bytes in their stages
compared to the first pair.
