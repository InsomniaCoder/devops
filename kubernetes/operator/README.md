# Overview

we will try to create a simple Kubernetes Operator using Operator SDK from this medium instruction: https://betterprogramming.pub/building-your-own-kubernetes-operator-easily-cab29ca51f96

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

