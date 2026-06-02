# Step 3 - Expose the MongoDB service

Pods are ephemeral; they can be restarted or moved, and their IP addresses change. To provide a stable endpoint for our database, we use a **Service**.

A Service provides a single, stable IP address and DNS name that points to one or more Pods.

### 1. Create the Service Manifest
Like you did in the last lessons and for the Pod, you can define the Service in a YAML manifest.

<details>
    <summary>Click to see the manifest definition</summary>

    apiVersion: v1
    kind: Service
    metadata:
    name: mongodb-service
    spec:
    selector:
        app: database
    ports:
        - port: 27017
        targetPort: 27017

</details>

### 2. Apply the Service
Apply the manifest to the cluster:

```bash
kubectl apply -f mongodb-service.yaml
```{{exec}}

### 3. Verify the Service
List the services to see the new `mongodb-service` and its Cluster-IP:

```bash
kubectl get svc
```{{exec}}
