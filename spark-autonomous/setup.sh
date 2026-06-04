#!/bin/bash

apt-get update -qq
apt-get install -y -qq docker-compose > /dev/null 2>&1

mkdir -p /root/spark-lab/data

cat > /root/spark-lab/docker-compose.yml << 'COMPOSEEOF'
version: "3.8"
services:
  spark-master:
    image: spark:python3
    container_name: spark-master
    command: /opt/spark/sbin/start-master.sh
    environment:
      - SPARK_NO_DAEMONIZE=true
    ports:
      - "8080:8080"
      - "7077:7077"
    volumes:
      - /root/spark-lab/data:/data
  spark-worker:
    image: spark:python3
    container_name: spark-worker
    command: /opt/spark/sbin/start-worker.sh spark://spark-master:7077
    environment:
      - SPARK_NO_DAEMONIZE=true
      - SPARK_WORKER_MEMORY=1g
      - SPARK_WORKER_CORES=1
    volumes:
      - /root/spark-lab/data:/data
    depends_on:
      - spark-master
COMPOSEEOF

cat > /root/spark-lab/data/logs.csv << 'CSVEOF'
request_id,endpoint,method,status_code,response_ms,user_id,date
1,/api/products,GET,200,45,u001,2024-01-15
2,/api/cart,POST,201,120,u002,2024-01-15
3,/api/products,GET,200,38,u003,2024-01-15
4,/api/checkout,POST,500,890,u001,2024-01-15
5,/api/products,GET,200,52,u004,2024-01-16
6,/api/login,POST,200,210,u005,2024-01-16
7,/api/cart,POST,201,135,u003,2024-01-16
8,/api/checkout,POST,200,430,u002,2024-01-16
9,/api/products,GET,404,25,u006,2024-01-16
10,/api/login,POST,401,88,u007,2024-01-17
11,/api/products,GET,200,41,u001,2024-01-17
12,/api/checkout,POST,200,395,u005,2024-01-17
13,/api/cart,DELETE,200,95,u003,2024-01-17
14,/api/products,GET,200,49,u008,2024-01-17
15,/api/checkout,POST,500,1200,u004,2024-01-18
16,/api/login,POST,200,198,u009,2024-01-18
17,/api/products,GET,200,44,u002,2024-01-18
18,/api/cart,POST,201,128,u007,2024-01-18
19,/api/checkout,POST,200,412,u009,2024-01-18
20,/api/products,GET,200,37,u010,2024-01-18
21,/api/login,POST,200,205,u010,2024-01-19
22,/api/products,GET,404,22,u011,2024-01-19
23,/api/cart,POST,201,140,u008,2024-01-19
24,/api/checkout,POST,200,388,u001,2024-01-19
25,/api/products,GET,200,55,u012,2024-01-19
CSVEOF

cat > /root/spark-lab/data/users.csv << 'USEEOF'
user_id,plan,country
u001,premium,Italy
u002,free,Germany
u003,premium,Italy
u004,free,France
u005,premium,Spain
u006,free,Italy
u007,free,Germany
u008,premium,France
u009,premium,Italy
u010,free,Spain
u011,free,France
u012,premium,Germany
USEEOF

cat > /root/spark-lab/data/baseline.py << 'PYEOF'
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, avg, round as _round

spark = SparkSession.builder \
    .appName("LogBaseline") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

df = spark.read.csv("/data/logs.csv", header=True, inferSchema=True)

print("\n=== Schema ===")
df.printSchema()

print("\n=== Sample rows ===")
df.show(5)

print("\n=== Total requests ===")
print(df.count())

print("\n=== Request count by status code ===")
df.groupBy("status_code") \
  .agg(count("request_id").alias("requests")) \
  .orderBy("requests", ascending=False) \
  .show()

spark.stop()
PYEOF
