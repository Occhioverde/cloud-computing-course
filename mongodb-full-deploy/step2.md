# Step 2 - Create a MongoDB pod

Now that our cluster is ready, let's deploy our first workload: a MongoDB database.

### 1. Create the Pod Manifest
As you may recall, MongoDB can be run in a container using the official `mongo` image and it will listen on port `27017` (more information available [on Docker Hub](https://hub.docker.com/_/mongo)).

To port this in our K8s cluster, you can define the manifest for the Pod in the YAML format you are already familiar with.

<details>
    <summary>Click to see the manifest definition</summary>

    apiVersion: v1
    kind: Pod
    metadata:
    name: mongodb
    labels:
        app: database
    spec:
    containers:
    - name: mongodb
        image: mongo:latest
        ports:
        - containerPort: 27017
    
</details>

### 2. Apply the Manifest
As always, use `kubectl apply` to send this definition to the Kubernetes API server to request the creation of the Pod:

```bash
kubectl apply -f mongodb-pod.yaml
```{{exec}}

### 3. Verify the Pod Status
It may take a few moments for the image to be downloaded and the container to start. To check the status of the Pod you can run:

```bash
kubectl get pods
```{{exec}}

You can also use the `-w` (watch) flag to see updates in real-time:

```bash
kubectl get pods -w
```{{exec}}

*(Press `Ctrl+C` to exit the watch mode once the Pod is `Running`)*

### 4. Inspect the Pod
To see more details about the Pod, including its IP address and events, use:

```bash
kubectl describe pod mongodb
```{{exec}}

In the next step, we will expose this Pod so it can be reached by other components in the cluster.
