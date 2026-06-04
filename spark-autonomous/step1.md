# Task 1 — Start the cluster and verify it

## Objective

Start the Spark standalone cluster and confirm:
- both containers are running
- the worker has registered with the master
- the Spark Web UI is accessible on port **8080** via the Traffic / Ports tab
- the data files are accessible at `/data/` inside the container

## Available commands

```
docker pull spark:python3
cd /root/spark-lab && docker-compose up -d
docker ps
docker exec spark-master ls /data/
```

## Note

The `data/` directory is mounted as a volume — files are already accessible
inside the container at `/data/` without any `docker cp` commands.

## Expected state when done

- Both containers in `Up` status
- Web UI on port 8080 shows 1 worker with 1 core and 1 GB memory
- `docker exec spark-master ls /data/` shows `logs.csv`, `users.csv`, `baseline.py`
