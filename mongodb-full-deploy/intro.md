# Deployment of MongoDB with Kubernetes from scratch

In this exercise, you will learn how to set up a Kubernetes cluster from the ground up and deploy a full MongoDB stack, including a web-based administration interface.

This scenario is designed as a **comprehensive review exercise**: it allows you to consolidate the Kubernetes and MongoDB concepts from previous lessons while learning the fundamental skills of cluster bootstrapping and management.

You will go through:
1.  **Installing a Kubernetes cluster** using `kubeadm`.
2.  **Deploying a MongoDB pod** using a standard container image.
3.  **Exposing MongoDB** with a ClusterIP service.
4.  **Deploying Mongo Express** and exposing it via a NodePort to access it from outside the cluster.
5.  **Interacting with your database** via the web interface to verify everything is working correctly.

This is a "Zero to Hero" lab, meaning that we will start with a bare Ubuntu machine and finish with a working database application.

Ready? Let's get started by setting up the cluster!
