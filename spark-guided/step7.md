# Step 7 — Join two DataFrames

## Create the join script

```
cat > /root/spark-lab/data/join_analysis.py << 'ENDOFSCRIPT'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, round as _round, avg

spark = SparkSession.builder.appName("JoinAnalysis").master("spark://spark-master:7077").getOrCreate()
spark.sparkContext.setLogLevel("WARN")

sales = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)
catalog = spark.read.csv("/data/catalog.csv", header=True, inferSchema=True)
sales = sales.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

print("\n=== Catalog schema ===")
catalog.printSchema()

enriched = sales.join(catalog, on="product", how="inner")

print("\n=== Enriched dataset (first 5 rows) ===")
enriched.select("product", "category", "region", "revenue", "supplier", "margin_pct").show(5)

print("\n=== Revenue and average margin by supplier ===")
enriched.groupBy("supplier").agg(_sum("revenue").alias("total_revenue"), avg("margin_pct").alias("avg_margin_pct")).orderBy("total_revenue", ascending=False).show()

print("\n=== High revenue AND high margin products (revenue > 1000, margin > 30%) ===")
enriched.groupBy("product", "margin_pct").agg(_sum("revenue").alias("total_revenue")).filter((col("total_revenue") > 1000) & (col("margin_pct") > 30)).orderBy("total_revenue", ascending=False).show()

spark.stop()
ENDOFSCRIPT
```{{exec}}

---

## Submit

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/join_analysis.py
```{{exec}}

---

## What to observe

**The join** — `sales.join(catalog, on="product", how="inner")` links each sales row
to the corresponding catalog row by product name.
Rows with no match in the catalog are dropped (inner join).

**Shuffle behind the join** — both DataFrames must be redistributed by the join key,
so Spark performs a shuffle sort-merge join.
Check the stages in the Web UI after the job completes — you will see more stages
than in the simple aggregation jobs.

**Combined aggregation** — after the join, columns from both DataFrames
are available in the same `groupBy().agg()` call.
