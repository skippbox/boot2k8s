#!/bin/sh

start() {
	/usr/local/bin/kubelet --api-servers=http://127.0.0.1:8080 --allow-privileged=true \
		--config=/usr/local/etc/kubernetes/manifests --v=2
}

stop() {
	kill $(pidof kubelet)
}

restart() {
	if pidof sshd > /dev/null; then
		stop && start
	else
		start
	fi
}


case $1 in
	start) start;;
	stop) stop;;
	restart) restart;;
	*) echo "Usage $0 {start|stop|restart}"; exit 1
esac
