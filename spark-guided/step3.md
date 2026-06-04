# Step 3 — Inspect the dataset and the script

## Look at the sales dataset

```
cat /root/spark-lab/data/sales.csv
```{{exec}}

The file has 20 rows with columns: `order_id`, `product`, `category`, `region`,
`quantity`, `unit_price`, `year`.

---

## Look at the product catalog

```
cat /root/spark-lab/data/catalog.csv
```{{exec}}

The catalog has one row per product with `supplier` and `margin_pct`.
You will use this file later for a join.

---

## Read the analysis script

```
cat /root/spark-lab/data/analysis.py
```{{exec}}

The script:
1. Creates a **SparkSession** connected to `spark://spark-master:7077`
2. Reads `sales.csv` with `inferSchema=True` — Spark detects column types automatically
3. Prints the schema and a sample
4. Adds a computed column `revenue = quantity * unit_price`
5. Groups by `category` and by `region`, computing total revenue and order count

Note `setLogLevel("WARN")` — this suppresses Spark's verbose internal logs
so your output is readable.

---

## Why `.master("spark://spark-master:7077")` matters

Without this call, Spark would run in **local mode** on a single thread
and would not use the worker container at all.
The master URL is what connects the driver to the distributed cluster.
