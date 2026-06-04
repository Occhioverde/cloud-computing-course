# Step 1 — Inspect the cluster

## Verify the containers are running

```
docker ps
```{{exec}}

You should see `spark-master` and `spark-worker` both in `Up` status.

---

## Check the Docker Compose configuration

```
cat /root/spark-lab/docker-compose.yml
```{{exec}}

Notice:
- `spark-master` exposes port **8080** (Web UI) and **7077** (cluster communication)
- `spark-worker` sets `SPARK_MASTER_URL=spark://spark-master:7077` to register with the master
- The worker has **1 GB memory** and **1 core** allocated

---

## Verify the worker registered with the master

```
docker logs spark-worker --tail 30
```{{exec}}

Look for the line:
`Worker: Successfully registered with master spark://spark-master:7077`

If you don't see it yet, wait 10 seconds and run the command again.

---

## Verify files are ready inside the container

```
docker exec spark-master ls /data/
```{{exec}}

You should see `sales.csv`, `catalog.csv`, and `analysis.py`.
