# A Minimum Working Example for Kubeflux

- [source](https://stackoverflow.com/questions/42564058/how-to-use-local-docker-images-with-minikube) 
- [Pi](https://github.com/ArangoGutierrez/Pi)
- [Multi-nodes solution](https://minikube.sigs.k8s.io/docs/handbook/registry/)
- [reference](https://hasura.io/blog/sharing-a-local-registry-for-minikube-37c7240d0615/)
## Setup
    - local cluster: minikube
    - Kubeflux: `kubesched.yaml`


## Using local docker image in minikube (multi-node can not use this method)

```bash
# Start minikube
minikube start --kuberbetes-version=1.19.8

# Set docker env
eval $(minikube docker-env)             # unix shells
minikube docker-env | Invoke-Expression # PowerShell

# Build image
docker build -t pi:latest .

# Run in minikube
kubectl run hello-foo --image=pi:latest --restart=Never --image-pull-policy=Never

# Check that it's running
kubectl get pods

eval $(minikube docker-env -u)
```



## Pushing to an in-cluster using Registry addon

- [sources](https://minikube.sigs.k8s.io/docs/handbook/pushing/)
- [refer](https://github.com/kubernetes/minikube/issues/6012)


## Something may work

Thanks! This worked.

I also got it to work with a separate docker registry container. Below are the steps:

    Configure your dockerd to specify insecure-registries as mentioned here: https://docs.docker.com/registry/insecure/ . echo { "insecure-registries":["ip:5000"] } >> /etc/docker/daemon.json Here ip refers to actual ip of your pc

    Start minikube with insecure-registries as:

minikube start --vm-driver=kvm2 --insecure-registry="ip:5000"

NOTE:

    I am using kvm2, set correct value it you use VMWare, Virtualbox, etc.

    Also specify the actual ip of your pc, instead of localhost ( use 'ip addr' command to get your ip)

    Correspondingly tag your images to 'ip:5000/image-name' and refer to the image by 'ip:5000/image-name' in the deployment.yml file to kubectl


## Steps:

```bash
   # we can find plugin version by reading from logs command's output and find corresponding k8s version from https://github.com/cmisale/scheduler-plugins 
   $ minikube start --kubernetes-version=v1.19.8
   $ kubectl create -f rbac.yaml 
   $ kubectl create -f ./kubesched.yaml 
   # find correct pod name with command minikube kubectl -- get pods -A
   $ kubectl logs -n kube-system  kubeflux-plugin-57c56dd87f-9c5km
   $ kubectl create -f pi.yaml
   # TODO: figure out why the pod is pending

   $ POD=$(kubectl get pod -l app=kubeflux -n kube-system -o jsonpath="{.items[0].metadata.name}")
   $ kubectl exec -it <podname> -n kube-system -- /bin/bash

   $ kubectl exec -it $(kubectl get pod -l app=kubeflux -n kube-system -o jsonpath="{.items[0].metadata.name}") -n kube-system -- /bin/bash

   $ kubectl cp kube-system/$(kubectl get pod -l app=kubeflux -n kube-system -o jsonpath="{.items[0].metadata.name}"):/home/data/jgf/kubecluster.json  kubecluster_cp.json
```

### How to copy file from pods to local

 - [refer](https://stackoverflow.com/questions/52407277/how-to-copy-files-from-kubernetes-pods-to-local-system)

 ```bash
    kubectl cp kube-system/kubeflux-plugin-7b5fb86f5f-8wqq2:/home/data/jgf/kubecluster.json  kubecluster_before.json
 ```



 ```shell
     NAME                       READY   STATUS      RESTARTS   AGE
    pi-job-kubeflux--1-2xdwq   0/1     Completed   0          13m
    pi-job-kubeflux--1-8htvc   0/1     Completed   0          13m
    pi-job-kubeflux--1-d2fps   0/1     Completed   0          12m
    pi-job-kubeflux--1-d6rsx   0/1     Completed   0          13m
    pi-job-kubeflux--1-fjwfh   0/1     Completed   0          13m
    pi-job-kubeflux--1-fx9gn   0/1     Completed   0          12m
    pi-job-kubeflux--1-hbgls   0/1     Completed   0          13m
    pi-job-kubeflux--1-hjmvc   0/1     Completed   0          13m
    pi-job-kubeflux--1-hxwtf   0/1     Completed   0          14m
    pi-job-kubeflux--1-kwqxd   0/1     Pending     0          12m
    pi-job-kubeflux--1-m7h4k   0/1     Completed   0          13m
    pi-job-kubeflux--1-pv7pq   0/1     Completed   0          13m
    pi-job-kubeflux--1-tcztt   0/1     Completed   0          12m
    pi-job-kubeflux--1-tp7zq   0/1     Completed   0          13m
    pi-job-kubeflux--1-xs99b   0/1     Completed   0          12m
    pi-job-kubeflux--1-zq46j   0/1     Completed   0          13m
 ```

```shell
    NAME                    READY   STATUS      RESTARTS   AGE
    pi-job-kubeflux-27crp   0/1     Completed   0          3m37s
    pi-job-kubeflux-4z2wb   0/1     Completed   0          6m1s
    pi-job-kubeflux-6ttq7   0/1     Completed   0          4m51s
    pi-job-kubeflux-7c75z   0/1     Completed   0          3m57s
    pi-job-kubeflux-7dg8w   0/1     Completed   0          2m7s
    pi-job-kubeflux-95vhj   0/1     Completed   0          4m15s
    pi-job-kubeflux-dhlp6   0/1     Completed   0          5m27s
    pi-job-kubeflux-hswth   0/1     Completed   0          2m45s
    pi-job-kubeflux-hvbhc   0/1     Completed   0          108s
    pi-job-kubeflux-j6rxg   0/1     Completed   0          4m33s
    pi-job-kubeflux-j7fcr   0/1     Completed   0          2m26s
    pi-job-kubeflux-k4ft7   0/1     Completed   0          89s
    pi-job-kubeflux-khm8x   0/1     Completed   0          5m44s
    pi-job-kubeflux-lnv7p   0/1     Completed   0          3m4s
    pi-job-kubeflux-rsvd6   0/1     Completed   0          3m20s
    pi-job-kubeflux-tj9p5   0/1     Completed   0          5m9s
    pi-job-kubeflux-vdkck   0/1     Pending     0          70s
```

```shell
    NAME                    READY   STATUS      RESTARTS   AGE
    pi-job-kubeflux-277b6   0/1     Completed   0          56s
    pi-job-kubeflux-42vqw   0/1     Completed   0          49s
    pi-job-kubeflux-57hld   0/1     Completed   0          2m40s
    pi-job-kubeflux-5n9xm   0/1     Completed   0          2m8s
    pi-job-kubeflux-5rd85   0/1     Completed   0          107s
    pi-job-kubeflux-8rxkn   0/1     Completed   0          2m19s
    pi-job-kubeflux-8zrdh   0/1     Completed   0          30s
    pi-job-kubeflux-bmkrk   0/1     Completed   0          39s
    pi-job-kubeflux-gvxvh   0/1     Pending     0          8s
    pi-job-kubeflux-k74pg   0/1     Completed   0          85s
    pi-job-kubeflux-knhlw   0/1     Completed   0          19s
    pi-job-kubeflux-mbjc2   0/1     Completed   0          117s
    pi-job-kubeflux-mv8sh   0/1     Completed   0          96s
    pi-job-kubeflux-np2l2   0/1     Completed   0          2m50s
    pi-job-kubeflux-nqc2z   0/1     Completed   0          75s
    pi-job-kubeflux-q5x7w   0/1     Completed   0          2m30s
    pi-job-kubeflux-z85qf   0/1     Completed   0          65s
```

```shell
    NAME                    READY   STATUS      RESTARTS   AGE
    pi-job-kubeflux-99l26   0/1     Completed   0          2m24s
    pi-job-kubeflux-d2srh   0/1     Completed   0          3m1s
    pi-job-kubeflux-f6gjt   0/1     Completed   0          86s
    pi-job-kubeflux-g8w4j   0/1     Completed   0          2m13s
    pi-job-kubeflux-ggkpl   0/1     Completed   0          2m51s
    pi-job-kubeflux-gl4wm   0/1     Completed   0          95s
    pi-job-kubeflux-kg46s   0/1     Completed   0          2m3s
    pi-job-kubeflux-ml8zw   0/1     Completed   0          68s
    pi-job-kubeflux-qslmk   0/1     Pending     0          54s
    pi-job-kubeflux-r97fc   0/1     Completed   0          2m43s
    pi-job-kubeflux-s444v   0/1     Completed   0          113s
    pi-job-kubeflux-s7tr5   0/1     Completed   0          3m19s
    pi-job-kubeflux-v7t9b   0/1     Completed   0          3m10s
    pi-job-kubeflux-whfwf   0/1     Completed   0          76s
    pi-job-kubeflux-wtqsk   0/1     Completed   0          104s
    pi-job-kubeflux-wx5xw   0/1     Completed   0          62s
    pi-job-kubeflux-xmbqc   0/1     Completed   0          2m34s

```

```shell
    NAME                    READY   STATUS      RESTARTS   AGE
    pi-job-kubeflux-47gq7   0/1     Completed   0          37s
    pi-job-kubeflux-4gxdr   0/1     Completed   0          40s
    pi-job-kubeflux-75tch   0/1     Completed   0          41s
    pi-job-kubeflux-8hjz8   0/1     Completed   0          38s
    pi-job-kubeflux-c25st   0/1     Completed   0          36s
    pi-job-kubeflux-d255m   0/1     Completed   0          34s
    pi-job-kubeflux-gdnls   0/1     Completed   0          45s
    pi-job-kubeflux-hk5dl   0/1     Completed   0          30s
    pi-job-kubeflux-j8g8s   0/1     Completed   0          44s
    pi-job-kubeflux-kdwkg   0/1     Completed   0          31s
    pi-job-kubeflux-p5qg6   0/1     Completed   0          33s
    pi-job-kubeflux-qtvkn   0/1     Completed   0          29s
    pi-job-kubeflux-rcmtc   0/1     Completed   0          47s
    pi-job-kubeflux-rlk56   0/1     Completed   0          42s
    pi-job-kubeflux-wdnnv   0/1     Completed   0          43s
    pi-job-kubeflux-zjnb6   0/1     Pending     0          28s
    pi-job-kubeflux-zvlnl   0/1     Completed   0          46s

```

 ### On CPU limit

 - [refer](https://learnk8s.io/setting-cpu-memory-limits-requests)


 ### Resource query

 - [refer](https://flux-framework.readthedocs.io/projects/flux-rfc/en/latest/spec_4.html)

 ### Kind local registry

 - [refer](https://kind.sigs.k8s.io/docs/user/local-registry/)


 ### Kind cluster with metrics server

 - [refer](https://www.scmgalaxy.com/tutorials/kubernetes-metrics-server-error-readiness-probe-failed-http-probe-failed-with-statuscode/)