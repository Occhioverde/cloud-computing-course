# Step 10 — Observe the final state in the Web UI

## Open the Web UI

Refresh port **8080** in your browser.

---

## What you should see

Under **Completed Applications** you should have at least **5 entries**:
- SalesAnalysis (two runs)
- FilterTransform
- JoinAnalysis
- CacheDemo
- SparkSQL

---

## Explore one application in detail

Click on **JoinAnalysis**. Explore:

- **Stages** — how many stages did the join job produce? Why more than the simple aggregation jobs?
- **Stage detail** — click on a shuffle stage. Note the **Shuffle Write** and **Shuffle Read** sizes.
- **Tasks** — how many tasks ran in each stage?

---

## Reflect on what you observed

On this tiny 20-row dataset, all jobs complete in seconds.
The concepts you practised — SparkSession, spark-submit, transformations and actions,
joins, cache, Spark SQL — are identical whether the dataset has 20 rows or 200 million.

The only things that change at scale are:
- more partitions → more parallelism → more tasks
- more data → more shuffle bytes → longer stage durations
- iterative workloads → cache becomes essential to avoid repeated disk reads

---

## Final check: list all submitted applications

```
docker logs spark-master --tail 50 | grep "app-"
```{{exec}}

You should see one log entry per submitted application,
confirming the master received and scheduled each job.
