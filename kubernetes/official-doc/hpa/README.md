# Horizontal Pod Autoscaler

## Doc

The Horizontal Pod Autoscaler is implemented as a `control loop`, with a period controlled by the controller manager's `--horizontal-pod-autoscaler-sync-period` flag (with a default value of 15 seconds).

During each period, the controller manager queries the resource utilization against the metrics specified in each HorizontalPodAutoscaler definition. The controller manager obtains the metrics from either the resource metrics API (for per-pod resource metrics), or the custom metrics API (for all other metrics).

1. per Pod

The controller fetches the metrics from the resource metrics API for each Pod targeted by the HorizontalPodAutoscaler.

Controller calculates `mean` of utilization value across all targeted pods.

2. custom

The HorizontalPodAutoscaler normally fetches metrics from a series of aggregated APIs (metrics.k8s.io, custom.metrics.k8s.io, and external.metrics.k8s.io).

## API

`autoscaling/v1`
`autoscaling/v2beta2`


