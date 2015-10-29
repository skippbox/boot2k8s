FROM boot2docker/boot2docker

#Install Kubelet and Kubelet manifest

ENV K8S_VERSION=v1.0.3

RUN curl -fL -o $ROOTFS/usr/local/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/kubelet && \
	chmod +x $ROOTFS/usr/local/bin/kubelet

#RUN mv kubelet /usr/bin/kubelet
RUN chmod +x $ROOTFS/usr/local/bin/kubelet
RUN mkdir -p $ROOTFS/usr/local/etc/kubernetes/manifests/
COPY kubernetes.yaml $ROOTFS/usr/local/etc/kubernetes/manifests/kubernetes.yaml

#Create Kubelet service

#RUN {           echo '[Unit]'; \
#                echo 'Description=Kubernetes Kubelet'; \
#                echo 'Documentation=https://github.com/kubernetes/kubernetes'; \
#                echo; \
#		echo '[Service]'; \
#		echo 'ExecStart=/usr/local/bin/kubelet \'; \
#                echo '--api-servers=http://127.0.0.1:8080 \'; \
#                echo '--allow-privileged=true \'; \
#                echo '--config=/usr/local/etc/kubernetes/manifests \'; \
#                echo '--v=2'; \
#                echo 'Restart=on-failure'; \
#                echo 'RestartSec=5'; \
#                echo; \
#                echo '[Install]'; \
#                echo 'WantedBy=multi-user.target'; \
#	} > $ROOTFS/etc/systemd/system/kubelet.service

#COPY k8s.sh $ROOTFS/etc/boot2docker/hooks/after-docker.d/k8s.sh
COPY kubelet.sh $ROOTFS/usr/local/etc/init.d/kubelet
RUN chmod +x $ROOTFS/usr/local/etc/init.d/kubelet
COPY k8s.sh $ROOTFS/etc/rc.d/k8s.sh
RUN chmod +x $ROOTFS/etc/rc.d/k8s.sh

RUN echo "/etc/rc.d/k8s.sh" >> $ROOTFS/opt/bootscript.sh

RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]
