# Node

## Component

 kubelet, a container runtime, and the kube-proxy

### Identification

Node name is unique and is used to identify node (metadata.name)

### Self-registration

when we run kubelet command, the default flag is --register-node

### Taints

Node taints, 

`kubectl taint nodes node1 key1=value1:NoSchedule`