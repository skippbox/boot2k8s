#!/bin/sh

run_start() {
	echo "Starting kubelet..."
		/usr/local/bin/kubelet --api-servers=http://127.0.0.1:8080 --cluster-dns=10.0.0.10 --cluster-domain=cluster.local --allow-privileged=true --config=/etc/kubernetes/manifests --kubeconfig=/etc/kubernetes/kubelet.kubeconfig --v=2 > /var/log/kubelet.log 2>&1 &
}

run_stop() {
	echo "Stopping kubelet..."
	P="x$(pidof kubelet)"

	if [ $P != "x" ]; then
		kill -9 $(pidof kubelet)
		for i in `docker ps|grep k8s|awk '{print $1}'`; do
          docker kill -s 9 $i
        done
	fi
}

run_restart() {
	if pidof kubelet > /dev/null; then
		run_stop && run_start
	else
		run_start
	fi
}


case $1 in
	start) run_start;;
	stop) run_stop;;
	restart) run_restart;;
	*) echo "Usage $0 {start|stop|restart}"; exit 1
esac
