# Exercise A complete

Well done. In this exercise you:

- deployed a Spark standalone cluster with Docker Compose (master + worker)
- verified cluster health via container logs and the Spark Web UI
- submitted PySpark jobs with `spark-submit` connected to the standalone master
- computed revenue aggregations using `groupBy`, `agg`, and `withColumn`
- filtered data with multi-condition `filter()` calls
- joined two DataFrames on a common key and aggregated across both
- used `cache()` to avoid re-reading data on repeated queries
- rewrote aggregations using Spark SQL syntax and `createOrReplaceTempView`
- observed stages, tasks, and shuffle boundaries in the Web UI

---

Continue to **Exercise B** to apply all of these concepts independently.
