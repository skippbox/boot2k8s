boot2k8s
========

boot2k8s is a [boot2docker](https://github.com/boot2docker/boot2docker) variant for [Kubernetes](http://kubernetes.io)

To build it you will need to have a Docker host, clone this repo and run `make`:

    $ docker version
    ...
    $ git clone https://github.com/skippbox/boot2k8s.git
    $ cd boot2k8s
    $ make

You will then have a `boot2k8s.iso` file that you can use to start a VirtualBox machine that will run Kubernetes solo.
