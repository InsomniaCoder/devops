# Overview

we will try to create a simple Kubernetes Operator using Operator SDK from this medium instruction: https://betterprogramming.pub/building-your-own-kubernetes-operator-easily-cab29ca51f96

and 

https://book.kubebuilder.io/cronjob-tutorial/controller-implementation.html
## Objective

To automatically remove a K8S Job that finished the execution and hang in Kubernetes API.

## Solution

We will create a `TTL Controller` to clean the job after TTL.

## Operator SDK

Operator SDK is a code generator to scaffold Operator.


## Installation

```
brew install operator-sdk

//create operator folder with go mod, main.go and Dockerfile
operator-sdk init job-purger --domain insomniacoder.github.com --repo github.com/insomniacoder/job-watcher-operator


//create /api/v1 folder and /controllers
operator-sdk create api --group batch --kind JobWatcher --version v1 --resource true --controller true
```

## Define CRD properties and status

Add custom properties for CRD in api/v1 structs

## Implement the reconciliation loop

Reconcilliation loop will receive a `Request` which contains
1. Namespace
2. Name of the resource

the reconciliation method will be called for every Object / CRD our Operator concerns with.




Reconciliation is on /controllers/jobwatcher_controller.go

//+kubebuilder: is a `marker`

it will create required object for us for example, create rbac to be able to get jobs

//+kubebuilder:rbac:groups=batch,resources=jobs,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=batch,resources=jobs/status,verbs=get
//+kubebuilder:rbac:groups:resources:verbs is used to tell KubeBuilder to create cluster role and role binding


