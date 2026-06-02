# Step 1 - Install a Kubernetes cluster

In this first step, we will transform a bare Ubuntu machine into a functional single-node Kubernetes cluster. We will use `kubeadm`, the official tool for bootstrapping Kubernetes clusters.

### 1. Disable Swap
Kubernetes requires swap to be disabled for the **kubelet** to work properly. Kubernetes is designed to manage resources (CPU and Memory) with high precision, so if the OS starts swapping memory to disk the kubelet cannot accurately track resource usage, leading to performance degradation and unpredictable OOM (Out Of Memory) kills. 

Note that failing to disable swap will trigger a preflight error during cluster initialization, and the kubelet service will fail to start.

```bash
swapoff -a
```{{exec}}

### 2. Install Dependencies
We need to install a few utility packages that allow `apt` to use repositories over HTTPS and manage the cryptographic keys required for package verification.

```bash
apt update
```{{exec}}

```bash
apt install -y apt-transport-https ca-certificates curl gpg
```{{exec}}

### 3. Add Kubernetes Repository
By default, standard Ubuntu repositories do not include the latest Kubernetes packages. We add the official Google-hosted repository to ensure we get the correct versions.

First, we download the public signing key and store it in a keyring. This key is used by `apt` to verify that the packages we download haven't been tampered with.

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```{{exec}}

Then, we add the repository to our sources list, referencing the keyring we just created.

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
```{{exec}}

### 4. Install Kubernetes Tools
We now install the three core components:

* **kubelet**: The "node agent" that runs on every machine in the cluster. It ensures that containers described in PodSpecs are running and healthy.
* **kubeadm**: The command-line utility used to initialize the cluster and join nodes. It automates complex tasks like generating certificates and setting up the control plane.
* **kubectl**: The command-line tool you use to talk to the Kubernetes API server (e.g., `kubectl get pods`).

```bash
apt update
```{{exec}}

```bash
apt install -y kubelet kubeadm kubectl
```{{exec}}

We use `apt-mark hold` to prevent these packages from being upgraded automatically during a system update. Kubernetes components often require coordinated upgrades to maintain compatibility, which is guaranteed only within one minor version (cfr. the ["Version Skew Policy"](https://kubernetes.io/releases/version-skew-policy/)).

```bash
apt-mark hold kubelet kubeadm kubectl
```{{exec}}

Enable the `kubelet` service so it starts automatically:

```bash
systemctl enable --now kubelet
```{{exec}}

*Note: The kubelet will start to crashloop at this point. This is normal because the cluster hasn't been initialized yet, so the kubelet has no configuration and no API server to talk to.*

### 5. Initialize the Cluster
Now we bootstrap the **Control Plane**. This - as you know - is the "brain" of our cluster.

When you run `kubeadm init`, several things happen:

1. **Preflight Checks**: It verifies that the system meets the requirements (e.g., swap is off).
2. **Certificate Authority (CA) generation**: Generates a self-signed CA to secure communication between components.
3. **Static Pods**: Generates manifests for the core components (**API Server**, **Scheduler**, and **Controller Manager**) so they can be run as containers by the kubelet.
4. **Etcd**: Sets up a local key-value store to hold all cluster data.

We use `--ignore-preflight-errors=NumCPU` because KillerCoda environments might have fewer than the recommended 2 CPUs. The `--pod-network-cidr` flag defines the range of IP addresses that will be assigned to Pods; this specific range (`10.244.0.0/16`) is required by the **Flannel** network plugin we will install later.

```bash
sudo kubeadm init --ignore-preflight-errors=NumCPU --pod-network-cidr=10.244.0.0/16
```{{exec}}

### 6. Configure kubectl
`kubectl` needs a configuration file (often called `kubeconfig`) to know where the cluster is and what credentials to use. `kubeadm` generates an admin configuration file at `/etc/kubernetes/admin.conf`, so we can copy it to our home directory in order to interact with the cluster through `kubectl`.

```bash
mkdir -p $HOME/.kube
```{{exec}}

```bash
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```{{exec}}

### 7. Understanding and Installing CNI
Kubernetes does not provide a built-in network implementation for Pods; instead, it defines a standard called the **Container Network Interface (CNI)**.

#### What is CNI?
CNI is a set of specifications and libraries that allow different networking solutions (like Flannel, Calico, or Weave) to plug into Kubernetes. Its primary job is to:
1. **Allocate IP addresses**: Each Pod must have a unique IP address across the entire cluster.
2. **Enable Connectivity**: Ensure that any Pod can communicate with any other Pod (even on different nodes) without NAT.

#### How it works:
When a Pod is scheduled to a node, the **kubelet** calls the CNI plugin. The plugin sets up a virtual network interface (veth pair) for the Pod, assigns it an IP from the CIDR range we defined earlier, and configures the host's routing table so traffic knows how to reach that Pod.

We will use **Flannel**, which is a simple "overlay" network and is extremely easy to set up. It creates a Layer 3 network that sits on top of the host network, allowing Pods to talk to each other regardless of which node they are on.

```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```{{exec}}

### 8. Allow Scheduling on Control Plane
In a production cluster, the Control Plane nodes are dedicated to managing the cluster and do not run user workloads (like our MongoDB). This is enforced by a **Taint**—a property applied to a node that repels Pods unless they have a matching "Toleration".

Since we are building a **single-node cluster**, we must remove this taint so that our MongoDB database can be scheduled on the same node as the control plane.

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```{{exec}}

*The trailing `-` in the command tells Kubernetes to remove the specified taint.*

Finally, verify that your node is ready:

```bash
kubectl get nodes
```{{exec}}

Once the status is `Ready`, the networking is functional, and you can proceed to deploy MongoDB!
