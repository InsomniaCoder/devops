# Service Account

A service account provides an identity for processes that run in a Pod.

Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account.


## Default

When we create a Pod without specifying serviceAccount.
```
spec.serviceAccountName
```
it is assigned with `default` service account.

## Create

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: build-robot
```

## Token

When we create a SA. token will be created and assigned.

```
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: 2015-06-16T00:12:59Z
  name: build-robot
  namespace: default
  resourceVersion: "272500"
  uid: 721ab723-13bc-11e5-aec2-42010af0021e
secrets:
- name: build-robot-token-bvbk5
```

### Manually create API token

```
apiVersion: v1
kind: Secret
metadata:
  name: build-robot-secret
  annotations:
    kubernetes.io/service-account.name: build-robot
type: kubernetes.io/service-account-token
```

when we describe, we will see

```
Data
====
ca.crt:         1338 bytes
namespace:      7 bytes
token:          ...
```

create service account to pull image


create secret
```
kubectl create secret docker-registry myregistrykey --docker-server=DUMMY_SERVER \
        --docker-username=DUMMY_USERNAME --docker-password=DUMMY_DOCKER_PASSWORD \
        --docker-email=DUMMY_DOCKER_EMAIL
```

add to sa

```
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: 2015-08-07T22:02:39Z
  name: default
  namespace: default
  uid: 052fb0f4-3d50-11e5-b066-42010af0d7b6
secrets:
- name: default-token-uudge
imagePullSecrets:
- name: myregistrykey
```

## User vs SA

User is globally uniqed across namespace, SA is namespace specific.


## SA Controller

A ServiceAccount admission controller
A Token controller
A ServiceAccount controller


### ServiceAccount Admission Controller

- If the pod does not have a ServiceAccount set, it sets the ServiceAccount to default
- It ensures that the ServiceAccount referenced by the pod exists, and otherwise rejects it.
- It adds a volume to the pod which contains a token for API access if neither the ServiceAccount automountServiceAccountToken nor the Pod's automountServiceAccountToken is set to false.
- It adds a volumeSource to each container of the pod mounted at /var/run/secrets/kubernetes.io/serviceaccount, if the previous step has created a volume for ServiceAccount token.
- If the pod does not contain any imagePullSecrets, then imagePullSecrets of the ServiceAccount are added to the pod.

### Token controller

Run as part of kube-controller-manager

- watches ServiceAccount creation and creates a corresponding ServiceAccount token Secret to allow API access.
- watches ServiceAccount deletion and deletes all corresponding ServiceAccount token Secrets.
- watches ServiceAccount token Secret addition, and ensures the referenced ServiceAccount exists, and adds a token to the Secret if needed.
- watches Secret deletion and removes a reference from the corresponding ServiceAccount if needed.

token controller needs a service account private key to sign generated service account tokens

and we need to pass the corresponding public key to the kube-apiserver using the --service-account-key-file flag. The public key will be used to verify the tokens during authentication.

### Service Account controller

A ServiceAccount controller manages the ServiceAccounts inside namespaces, and ensures a ServiceAccount named "default" exists in every active namespace.


Token created from Token controller is encoded hash-key and will be used as Bearer token in api call to API-server



