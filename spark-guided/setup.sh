#!/bin/bash

# Install Docker Compose
apt-get update -qq
apt-get install -y -qq docker-compose > /dev/null 2>&1

# Create working directory
mkdir -p /root/spark-lab

# Create Docker Compose file
cat > /root/spark-lab/docker-compose.yml << 'COMPOSEEOF'
version: "3.8"
services:
  spark-master:
    image: bitnami/spark:3.5
    container_name: spark-master
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    ports:
      - "8080:8080"
      - "7077:7077"
  spark-worker:
    image: bitnami/spark:3.5
    container_name: spark-worker
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://spark-master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    depends_on:
      - spark-master
COMPOSEEOF

# Create sales dataset
cat > /root/spark-lab/sales.csv << 'CSVEOF'
order_id,product,category,region,quantity,unit_price,year
1001,Laptop,Electronics,North,2,899.99,2023
1002,Desk Chair,Furniture,South,5,249.99,2023
1003,Keyboard,Electronics,North,10,79.99,2023
1004,Monitor,Electronics,East,3,399.99,2023
1005,Bookshelf,Furniture,West,2,189.99,2023
1006,Mouse,Electronics,South,15,39.99,2023
1007,Standing Desk,Furniture,North,1,599.99,2023
1008,Headphones,Electronics,East,8,149.99,2023
1009,Filing Cabinet,Furniture,South,3,299.99,2023
1010,Webcam,Electronics,West,6,89.99,2023
1011,Laptop,Electronics,South,1,899.99,2024
1012,Desk Chair,Furniture,North,3,249.99,2024
1013,Keyboard,Electronics,West,20,79.99,2024
1014,Monitor,Electronics,South,4,399.99,2024
1015,Bookshelf,Furniture,East,1,189.99,2024
1016,Mouse,Electronics,North,25,39.99,2024
1017,Standing Desk,Furniture,West,2,599.99,2024
1018,Headphones,Electronics,South,12,149.99,2024
1019,Filing Cabinet,Furniture,East,2,299.99,2024
1020,Webcam,Electronics,North,9,89.99,2024
CSVEOF

# Create product catalog
cat > /root/spark-lab/catalog.csv << 'CATEOF'
product,supplier,margin_pct
Laptop,TechSupply Inc,22
Keyboard,TechSupply Inc,35
Monitor,DisplayCorp,28
Mouse,TechSupply Inc,40
Headphones,AudioWorld,32
Webcam,TechSupply Inc,30
Desk Chair,OfficePro,25
Standing Desk,OfficePro,20
Bookshelf,FurnitureCo,38
Filing Cabinet,FurnitureCo,30
CATEOF

# Create baseline analysis script
cat > /root/spark-lab/analysis.py << 'PYEOF'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, avg, round as _round, count

spark = SparkSession.builder \
    .appName("SalesAnalysis") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/sales.csv", header=True, inferSchema=True)

print("\n=== Dataset schema ===")
df.printSchema()

print("\n=== First 5 rows ===")
df.show(5)

print("\n=== Total records ===")
print(df.count())

df = df.withColumn("revenue", _round(col("quantity") * col("unit_price"), 2))

print("\n=== Revenue by category ===")
df.groupBy("category") \
  .agg(_sum("revenue").alias("total_revenue")) \
  .orderBy("total_revenue", ascending=False) \
  .show()

print("\n=== Revenue by region ===")
df.groupBy("region") \
  .agg(_sum("revenue").alias("total_revenue"), count("order_id").alias("orders")) \
  .orderBy("total_revenue", ascending=False) \
  .show()

spark.stop()
PYEOF

# Pull image first (blocking)
docker pull bitnami/spark:3.5 > /dev/null 2>&1

# Start the cluster (non-blocking by design — docker-compose returns immediately)
cd /root/spark-lab
docker-compose up -d

# Wait until spark-master container is running
until docker ps | grep -q "spark-master"; do sleep 3; done

# Wait until Spark master process is actually ready (check logs for startup message)
until docker logs spark-master 2>&1 | grep -q "Master: Starting Spark master"; do sleep 3; done

# Wait until worker has registered
until docker logs spark-worker 2>&1 | grep -q "Successfully registered with master"; do sleep 3; done

# Copy data files into the container
docker exec spark-master mkdir -p /data
docker cp /root/spark-lab/sales.csv spark-master:/data/sales.csv
docker cp /root/spark-lab/catalog.csv spark-master:/data/catalog.csv
docker cp /root/spark-lab/analysis.py spark-master:/data/analysis.py
