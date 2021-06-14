## KubeBuilder

## Overview

[KubeBuilder](https://github.com/kubernetes-sigs/kubebuilder) is a framework to develop a Kubernetes API using Kubernetes Custom Resource Definitions (CRDs)

https://book.kubebuilder.io/

## Topics

- How to batch multiple events into a single reconciliation call
- How to configure periodic reconciliation
Forthcoming
- When to use the lister cache vs live lookups
- Garbage Collection vs Finalizers
- How to use Declarative vs Webhook Validation
- How to implement API versioning


### Create a project

```
kubebuilder init --domain my.domain --repo my.domain/guestbook
```

### Create new API (group/version)

```
kubebuilder create api --group webapp --version v1 --kind Guestbook
```
this will create an API

`api/v1/guestbook_types.go`

api has fields and status

status defines the observed state of the API

and reconciliation business logic for Guestbook is

`controllers/guestbook_controller.go`

### API Design

all serialized fields must be camelCase

omitempty struct tag to mark that a field should be omitted from serialization when empty

 three forms of numbers: int32 and int64 for integers, and resource.Quantity for decimals

 ```
 Quantities are a special notation for decimal numbers that have an explicitly fixed representation that makes them more portable across machines. You’ve probably noticed them when specifying resources requests and limits on pods in Kubernetes.

They conceptually work similar to floating point numbers: they have a significand, base, and exponent. Their serializable and human readable format uses whole numbers and suffixes to specify values much the way we describe computer storage.
```

### Controllers

Controllers are the core of Kubernetes, and of any operator.

Controllers make sure object states in the cluster match the definition.

Each controller focuses on one `root` Kind, but may interact with other Kinds.

the logic that implements this reconciliation is Reconciler.

Reconciler takes the name of an object, and return whether or not we need to try again.

We return an empty result and no error, which indicates to controller-runtime that we’ve successfully reconciled this object and don’t need to try again until there’s some changes.

```
type CronJobReconciler struct {
    client.Client
    Log    logr.Logger
    Scheme *runtime.Scheme
}
```

```
func (r *CronJobReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    _ = r.Log.WithValues("cronjob", req.NamespacedName)

    // your logic here

    return ctrl.Result{}, nil
}
```

Our Request just has a name, but we can use the client to fetch that object from the cache.

The context is used to allow cancelation of requests, and potentially things like tracing. It’s the first argument to all client methods. 

The Background context is just a basic context without any extra data or timing restrictions.

## Operator Components

### Process (main.go) -> one per cluster

### Manager (sigs.k8s.io/controller-runtime/pkg/manager)
 -> one per process
// export Metrics, Handle webhook certs, cache events, broadcasts events to Controllers

#### Manager/Client 
-> Communicate with API server
#### Manager/Cache 
-> Holds recently watched or get objects. Uses by Controller and Webhook.

### Controllers (sigs.k8s.io/controller-runtime/pkg/controller)

One per Kind (CRD)

Owns resource created by it

Use Caches and Events and get events via Filters

Controller calls reconcile each time it gets an event.


#### Predicate (sigs.k8s.io/controller-runtime/pkg/predicate)

Filters a stream of events, passing only those required action by controller.

#### Reconciler (sigs.k8s.io/controller-runtime/pkg/reconciler)

User-provided logic 

### Webhook  (sigs.k8s.io/controller-runtime/pkg/webhook)

Zero or one Webhook. One per kind that is reconciled.

#### Admission Request
#### Defaulter 

set unset fields in spec

#### Validator

Reject poorly formed object











