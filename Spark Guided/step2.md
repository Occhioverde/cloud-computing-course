# Step 2 — Explore the Spark Web UI

## Open the Web UI

The Spark master exposes a Web UI on port **8080**.

Click the **Traffic / Ports** tab at the top of this page, then open port **8080**.

---

## What you should see

- **URL**: `spark://spark-master:7077`
- **Workers**: 1 worker registered, with 1 core and 1 GB memory
- **Running Applications**: empty — no jobs submitted yet
- **Completed Applications**: empty

---

## Note the available resources

Before submitting any job, note the total cluster resources:
- Cores in use: **0** / 1
- Memory in use: **0 MB** / 1024 MB

When you submit a job, Spark will allocate executor resources from this pool
and you will see the numbers change.

---

## Keep the tab open

Leave the Web UI open in a separate browser tab.
You will come back to it at each step to observe how jobs appear and complete.
