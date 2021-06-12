
## Overview

This is the detail of implementing self-hosted K8S cluster on cloud providers based on Kubernetes The hard way.

### Components

kubernetes v1.21.0
containerd v1.4.4
coredns v1.8.3
cni v0.9.1
etcd v3.4.15

### Directory

under `/var/lib`
```
  authconfig cni docker filebeat kubelet
  amazon calico cloud containerd dockershim nfs      
```

we have binaries stored at /etc/kubernetes with these components

bin -> store kubelet, kube-proxy
cni -> bin net.d network
conf -> kube-proxy-config.yml
kubeconfig -> bootstrap.kubeconfig kubelet.kubeconfig kube-proxy.kubeconfig
log
pki -> certificates
script -> clean.sh init.sh

init script

```
!/bin/bash

LOCK_FILE="/etc/kubernetes/.lock"

# check lock
[ -e "$LOCK_FILE" ] && exit 2

# create dirs
mkdir -p /var/lib/kubelet /var/lib/filebeat /var/lib/calico

# AWS private ip, instance id
PRIVATE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

hostnamectl set-hostname  $INSTANCE_ID

cat > /etc/systemd/system/kubelet.service <<-EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/srv/kubernetes/bin/kubelet \
  --address=${PRIVATE_IP} \
  --bootstrap-kubeconfig=/srv/kubernetes/kubeconfig/bootstrap.kubeconfig \
  --kubeconfig=/srv/kubernetes/kubeconfig/kubelet.kubeconfig \
  --cert-dir=/srv/kubernetes/pki \
  --network-plugin=cni \
  --cni-conf-dir=/srv/kubernetes/cni/net.d \
  --cni-bin-dir=/srv/kubernetes/cni/bin \
  --cluster-dns=10.239.0.10 \
  --cluster-domain=cluster.nonprod \
  --authorization-mode=Webhook \
  --client-ca-file=/srv/kubernetes/pki/ca.pem \
  --rotate-certificates=true \
  --allow-privileged=true \
  --runtime-cgroups=/systemd/system.slice \
  --kubelet-cgroups=/systemd/system.slice \
  --v=2 \
  --node-labels=internal-ip=${PRIVATE_IP} \
  --node-labels=node-role.kubernetes.io/${PRIVATE_IP}=true \
  --node-labels=node-role.kubernetes.io/node=true \
  --node-labels=k8s.wecash.io/generation=2 \
  --node-labels=k8s.wecash.io/env=nonprod \
  --kube-reserved=cpu=100m,memory=300Mi \
  --system-reserved=cpu=100m,memory=200Mi \
  --eviction-minimum-reclaim=memory.available=1Gi \
  --image-gc-low-threshold=50 \
  --image-gc-high-threshold=70 \
  --serialize-image-pulls=false \
  --logtostderr=false \
  --cloud-provider=aws \
  --log-dir=/srv/kubernetes/log
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

## set calico nodename
echo -n "$INSTANCE_ID" > /var/lib/calico/nodename

systemctl daemon-reload
systemctl enable kubelet.service
systemctl enable kube-proxy.service
systemctl restart kubelet.service
systemctl restart kube-proxy.service

# add lock
touch $LOCK_FILE
```


### Reference
https://github.com/kelseyhightower/kubernetes-the-hard-way