#!/bin/sh

KUBE_CERT=/var/run/kubernetes/kubelet/cert.pem
KUBE_KEY=/var/run/kubernetes/kubelet/key.pem

run_start() {
	echo "Starting kubelet..."
	if [ -f $KUBE_CERT ] && [ -f $KUBE_KEY ]; then 
		/usr/local/bin/kubelet --api-servers=http://127.0.0.1:8080 --allow-privileged=true --config=/etc/kubernetes/manifests --tls-cert-file=$KUBE_CERT --tls-private-key-file=$KUBE_KEY --v=2 > /var/log/kubelet.log 2>&1 &
	else
		/usr/local/bin/kubelet --api-servers=http://127.0.0.1:8080 --allow-privileged=true --config=/etc/kubernetes/manifests --v=2 > /var/log/kubelet.log 2>&1 &
	fi

}

run_stop() {
	echo "Stopping kubelet..."
	kill -9 $(pidof kubelet)
}

run_restart() {
	if pidof sshd > /dev/null; then
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
