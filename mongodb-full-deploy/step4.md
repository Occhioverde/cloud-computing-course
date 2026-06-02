# Step 4 - Interact with your MongoDB server

To easily interact with our database for outside of the cluser, we will deploy **Mongo Express**, a web-based administrative interface for MongoDB.

### 1. Create the Mongo Express Manifest
First of all, we need to create the manifest for the Mongo Express Pod. Similarly to MongoDB, we will use the official `mongo-express` image, which listens on port `8081`.

Try to write the manifest on your own, finding the necessary information on the [Docker Hub page](https://hub.docker.com/_/mongo-express) for the image.

<details>
    <summary>Click to see the manifest definition</summary>

    apiVersion: v1
    kind: Pod
    metadata:
    name: mongo-express
    labels:
        app: admin-ui
    spec:
    containers:
    - name: mongo-express
        image: mongo-express:latest
        ports:
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_SERVER
        value: "mongodb-service"

  Notice the environment variable `ME_CONFIG_MONGODB_SERVER`, which points to the service name we created in the previous step (`mongodb-service`).

</details>

### 2. Create the Service Manifest
To access Mongo Express from outside the cluster, we need to expose it with a `NodePort` service.

As you may know, this type of service will allocate a port on the external permiteter of the cluster (in the range 30000-32767) and forward traffic from that port to the target port on the Pod. This way, we will be able to access the Mongo Express interface from outside of Killercoda.

Write the manifest for the `NodePort` service on your own, using the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) as a reference.

<details>
    <summary>Click to see the manifest definition</summary>

    apiVersion: v1
    kind: Service
    metadata:
    name: mongo-express-service
    spec:
    type: NodePort
    selector:
        app: admin-ui
    ports:
        - port: 8081
        targetPort: 8081
        nodePort: 30081

</details>

### 3. Deploy Mongo Express
Apply the two manifests to create the Pod and the Service:

```bash
kubectl apply -f mongo-express-pod.yaml
```{{exec}}

```bash
kubectl apply -f mongo-express-service.yaml
```{{exec}}

### 3. Verify Deployment
Check that the new Pod is running:

```bash
kubectl get pods
```{{exec}}

And check the Service:

```bash
kubectl get svc
```{{exec}}

### 4. Access the Interface
We explicitly set the `nodePort` to `30081` so, if everythig went as planned, you should be able to access MongoDB Express by visiting <{{TRAFFIC_HOST1_30081}}>. In general, you can access any port you previously exposed by clicking on the three lines on the top right corner of the Killercoda interface, then on "Traffic / Ports", typing the port number (in this case `30081`) and clicking "Access".

Open the web interface and you should see the Mongo Express dashboard, connected to your MongoDB instance (the default credentials are `admin`/`pass`)!

Congratulations! You have built a Kubernetes cluster from scratch and deployed a multi-tier application.
