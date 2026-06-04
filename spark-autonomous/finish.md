# Exercise B complete

You have independently:

- started and verified a Spark standalone cluster
- submitted a baseline job with `spark-submit`
- written PySpark scripts covering filter, withColumn, join, cache, and Spark SQL
- answered analytical questions on a web server access log dataset
- observed job lifecycle, stage boundaries, and input sizes in the Web UI

## Self-check

Before closing the environment, verify:

- [ ] Web UI shows at least 5 completed applications
- [ ] `/api/checkout` appeared as the slowest endpoint in your filter analysis
- [ ] The join with the user table produced results grouped by `plan` and `country`
- [ ] The cached version of the join DataFrame was reused across multiple aggregations
- [ ] All three SQL queries returned non-empty results
