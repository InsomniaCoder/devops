# Open Policy Agent 

## Overview

The [Open Policy Agent](https://github.com/open-policy-agent/opa) (OPA) is an open source, general-purpose policy engine that enables unified, context-aware policy enforcement across the entire stack.

Examples of policies

- Can user X call operation Y on resource Z?
- What clusters should workload W be deployed to?
- What tags must be set on resource R before it's created?

services executes queries to OPA to retrieve rules instead of hardcodded them in their systems.

### Rego (pronounced “ray-go”) 

OPA policies are expressed in a high-level declarative language called Rego

### What for??

We can use OPA to write `policies` as a code

- create custom cloud infrastructure policies
- Check for public and unencrypted S3 buckets
- Which cloud regions are allowed
- Which machine images (e.g. AMIs) are allowed
- Make sure VPC flow logs are configured
- Which instance sizes (e.g. EC2) are allowed
- Check for least permissions in IAM policies
- Which ingress rules are allowed for Security Groups

#### Kubernetes

- developing access policies for Kubernetes
- we can intercept requests to the Kubernetes API server before the relative objects, providing intent for desired cluster state, can be persisted to the etcd key/value object store.


https://medium.com/capital-one-tech/policy-enabled-kubernetes-with-open-policy-agent-3b612b3f0203