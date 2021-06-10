## Query Command

// get labels of giveb pod
kgp podname -o=jsonpath='{.metadata.labels}'

## Run command

// run a debug pod to curl or to telnet within cluster
// run alpine as busybox and delete when exit
// we can run apt-get to install curl once initiated
// apk add --update curl 
kubectl run -i --tty --rm busybox-test --image=alpine -- sh


## Helm

// list release
helm ls 

// list all release
helm ls -a

// show information about current release
// values
helm get values test
// all k8s objects
helm get manifest test
// all info, chart name, manifest, values and notes
helm get all test

### Use official chart

// add and upgrade repo
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
helm repo update

// search  for chart and all versions available
helm search repo bitnami/mysql --versions

// download official chart to see implementation and values
helm pull bitnami/mysql --version 8.5.8 . --untar

// view official chart info
helm show chart bitnami/redis
helm show values bitnami/redis


// install release from official chart with version
helm upgrade mysql bitnami/mysql --version 8.5.8 -f values-uat01.yaml --install

// install or upgrade a chart (run in chart directory)
helm upgrade test . -f values-uat01.yaml -n namespace --install
// install or upgrade a chart with dry run (run in chart directory)
helm upgrade test . -f values-uat01.yaml -n namespace --install --dry-run
// helm upgrade and set just new values
helm upgrade --reuse-values --set image.registry=docker.io/bitnami/redis --set image.tag=6.0.7-debian-10-r0  redis stable/redis --version 3.2.5  --dry-run

//uninstall a chart
helm uninstall test

// rollback to previous release
helm rollback test