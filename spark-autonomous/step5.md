# Task 5 — Cache and reuse

## Objective

Write a script `cache_demo.py` that:

1. Reads `logs.csv` and joins it with `users.csv`
2. Caches the enriched (joined) DataFrame
3. Runs three different aggregations on the cached DataFrame:
   - request count by `plan`
   - average `response_ms` by `endpoint`
   - request count by `date`
4. Unpersists the cache at the end
5. Prints a timing message before and after each group of aggregations
   to illustrate the cache effect

## Available functions

```python
import time

df.cache()
df.count()       # materialise the cache

t0 = time.time()
# ... aggregations ...
print(f"Time: {time.time() - t0:.2f}s")

df.unpersist()
```

## What to verify in the Web UI

Open the **CacheDemo** application after it completes.
Compare the **Input Size** of the stages in the first group of aggregations
vs the second group — the second group should read from memory, not from disk.

## Commands

Write your script to `/root/spark-lab/data/cache_demo.py`, then submit:

```
docker exec spark-master /opt/spark/bin/spark-submit --master spark://spark-master:7077 /data/cache_demo.py
```
