#!/bin/sh
kubectl delete -f ./pi-job-kubeflux-segfault.yaml
kubectl delete -f ./pi-job-kubeflux.yaml
kubectl delete -f ./pi-job-default.yaml
