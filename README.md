boot2k8s
========

boot2k8s is a [boot2docker](https://github.com/boot2docker/boot2docker) variant for [Kubernetes](http://kubernetes.io).
It is distributed as an ISO image that you can use to create a virtual machine in VirtualBox. That VM will run Kubernetes in a single node (a.k.a Kubernetes solo).
boot2k8s is used to get started with Kubernetes, learn the basic concepts and start developing your cloud native application.

Download
--------

The ISO for `boot2k8s` is available on the [release page](https://github.com/skippbox/boot2k8s/releases).
After downloading the ISO, create a new virtual machine in VirtualBox. You can use the VirtualBox UI or start it with the CLI tools:

    $ VBoxManage createvm --name boot2k8s --ostype "Linux_64" --register
    $ VBoxManage storagectl boot2k8s --name "IDE Controller" --add ide
    $ VBoxManage storageattach boot2k8s --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ./boot2k8s.iso
    $ VBoxManage modifyvm boot2k8s --memory 1024
    $ VBoxManage modifyvm boot2k8s --memory 1024 --vrde on --vrdeaddress 127.0.0.1 --vrdeport 3390 --vrdeauthtype null
    $ VBoxManage startvm boot2k8s --type headless
    $ VBoxManage controlvm boot2k8s natpf1 k8s,tcp,,8080,,8080

You will have a running VM, that runs k8s in it all in a single node.
Port 8080 is exposed on the host at `http://localhost:8080`

To connect to the VM with remote desktop you will need to have the Virtual Box extension pack that corresponds to your version of VBox.
With the pack installed you will be able to connect to the VM with VRDE at `127.0.0.1:3390`

Build from source
-----------------

To build the ISO yourself from source, you will need to have a Docker host, clone this repo and run `make`:

    $ docker version
    ...
    $ git clone https://github.com/skippbox/boot2k8s.git
    $ cd boot2k8s
    $ make

You will then have a `boot2k8s.iso` file that you can use to start a VirtualBox machine that will run Kubernetes solo.

Run a VM with a new ISO
-----------------------

If you did not clone the repo and just downloaded the ISO image from the release page, create a VirtualBox VM manually through the VirtualBox UI.
Setup portforwarding on the default NAT interface to expose port 8080 of the host to port 8080 of the guest.

If you have cloned the repository you can automatically create the VirtualBox VM based on boot2k8s:

    $ make run


Usage
-----

If you do not have the `kubectl` Kubernetes client, get it:

Darwin:

    $ wget https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/darwin/amd64/kubectl

Linux:

    $ wget https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/kubectl

Then make it exectuable and put it in your PATH, for example:

    $ chmod +x kubectl && sudo ln -sf $PWD/kubectl /usr/local/bin/

Then, once the Kubernetes API server starts running you can use `kubectl` to start using Kubernetes:

    $ kubectl get pods
    NAME                          READY     STATUS    RESTARTS   AGE
    kube-controller-boot2docker   5/5       Running   0          1s
    $ kubectl get pods
    NAME                          READY     STATUS    RESTARTS   AGE
    kube-controller-boot2docker   5/5       Running   0          3s

Support
-------

If you experience problems with `boot2k8s` or want to suggest improvements please file an [issue](https://github.com/skippbox/boot2k8s/issues).
