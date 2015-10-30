boot2k8s
========

boot2k8s is a [boot2docker](https://github.com/boot2docker/boot2docker) variant for [Kubernetes](http://kubernetes.io).
It is distributed as an ISO image that you can use to create a virtual machine in VirtualBox. That VM will run Kubernetes in a single node (a.k.a Kubernetes solo).
boot2k8s is used to get started with Kubernetes, learn the basic concepts and start developing your cloud native application.

Download
--------

The ISO for `boot2k8s` is available on the [release page](https://github.com/skippbox/boot2k8s/releases).

Build
-----

To build it you will need to have a Docker host, clone this repo and run `make`:

    $ docker version
    ...
    $ git clone https://github.com/skippbox/boot2k8s.git
    $ cd boot2k8s
    $ make

You will then have a `boot2k8s.iso` file that you can use to start a VirtualBox machine that will run Kubernetes solo.

Run
---

If you have clone the repository you can automatically create the VirtualBox VM based on boot2k8s:

    $ make run

Once the Kubernetes API server starts running you can use `kubectl` to start using Kubernetes:

    $ kubectl get pods
    NAME                          READY     STATUS    RESTARTS   AGE
    kube-controller-boot2docker   5/5       Running   0          1s
    $ kubectl get pods
    NAME                          READY     STATUS    RESTARTS   AGE
    kube-controller-boot2docker   5/5       Running   0          3s

Support
-------

If you experience problems with `boot2k8s` or want to suggest improvements please file an [issue](https://github.com/skippbox/boot2k8s/issues).
