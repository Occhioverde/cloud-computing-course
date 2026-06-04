# Step 4 — Submit your first PySpark job

## Submit the job with spark-submit

```
docker exec spark-master spark-submit --master spark://spark-master:7077 /data/analysis.py
```{{exec}}

The job takes about 30–60 seconds. While it runs:
- Switch to the Web UI tab and refresh
- You should see **SalesAnalysis** under **Running Applications**
- Watch the worker's memory and core usage change

---

## Read the output

When the job completes, find these sections in the output:

**Schema** — verify that `quantity` and `unit_price` were correctly inferred as numeric types.

**First 5 rows** — check the data looks correct.

**Revenue by category** — which category generated more total revenue?

**Revenue by region** — which region had the highest revenue? Which had the most orders?

---

## Check the Web UI after completion

Refresh port 8080. **SalesAnalysis** should now appear under **Completed Applications**.

Click on the application name and explore:
- **Stages** — how many stages did the job produce?
- **Tasks** — how many tasks per stage?

The `groupBy().agg()` calls each produce a shuffle boundary,
which is why you see multiple stages.
