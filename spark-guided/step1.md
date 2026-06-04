# Step 1 — Start the cluster

## Pull the Spark image

```
docker pull spark:python3
```{{exec}}

---

## Start the cluster

```
cd /root/spark-lab && docker-compose up -d
```{{exec}}

---

## Wait for the master to be ready

```
until docker logs spark-master 2>&1 | grep -q "MasterWebUI: Bound to"; do sleep 3; done && echo "Master ready"
```{{exec}}

---

## Wait for the worker to register

```
until docker logs spark-worker 2>&1 | grep -q "Successfully registered with master"; do sleep 3; done && echo "Worker registered"
```{{exec}}

---

## Verify both containers are running

```
docker ps
```{{exec}}

You should see `spark-master` and `spark-worker` both in `Up` status.

---

## Copy the data files into the master container

```
docker exec spark-master mkdir -p /data
```{{exec}}

```
docker cp /root/spark-lab/sales.csv spark-master:/data/sales.csv
```{{exec}}

```
docker cp /root/spark-lab/catalog.csv spark-master:/data/catalog.csv
```{{exec}}

```
docker cp /root/spark-lab/analysis.py spark-master:/data/analysis.py
```{{exec}}

---

## Verify the files are inside the container

```
docker exec spark-master ls /data/
```{{exec}}

You should see `sales.csv`, `catalog.csv`, and `analysis.py`.
