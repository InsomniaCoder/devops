# CANAL

## Overview

CANAL is acutally a combination of Calico and Flannel.

## CNI

CNI stands for Container Networking Interface

It is a standard that defines configuration of container networking when container is created and destroyed.

Examples of CNI libraries are Calico, Weave, Canal.

## Container Network

Container networking is a mechanism that a container can connect to other containers, host or internet.

Docker has multiple container runtime to choose:

- none: no connectivity
- host: add container to host's networking stack
- default bridge: each container can connect to each other using IP address
- custom bridge: additional flexibility to default bridge, isolation
  
CNI: Dynamically configuring the appropriate network configuration and resources when containers are provisioned or destroyed.

For example,

container runtime calls network plugins interface to allocate IP Address and register it when container starts and calls to delete when container is deleted.

For Kubernetes, `kubelet` can automatically configures network for pod when it starts.


## Terminology

`L2 Networking`: dataframe transferring between 2 nodes (Ethernet)
`L3 Networking`: "network" layer, routing packets between hosts (IPv4, IPv6)
`Overlay network`: virtual, logical network on top of existing network. used for abstraction of current network for more secure, and separate.
`BGP`: “border gateway protocol" is used to manage how packets are routed between edge routers


## Comparison

### Flannel

Easy to install

it is a single packaged binary, `flanneld'

it uses existing Kubernetes cluster's `etcd` to store information via API

Flannel creates L3 IPv4 overlay spans across all nodes.

each node is given subnet to allocate ip for their pods.

when pod is provisioned, docker bridge interface in each node allocates address for each new container.

Pods in the same host can communicate using docker bridge.

if pods are in different host, `flanneld` will encapsulate packets and send to another node using UDP.

### Calico

Best known for performance, flexibility and power.

it provides more than just network connectivity. it also concerns security, and administration.

Calico does not use overlay network.

it configures L3 network layer and use BGP to route packets between hosts.

packets does not need to be wrapped in UDP packets. 

### Canal

integrate the networking layer provided by flannel with the networking policy capabilities of Calico

so, networking layer is overlayed by Flannel and network policies are based on Calico's plugins.

