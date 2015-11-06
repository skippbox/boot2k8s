# Copyright 2015 Skippbox, Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM boot2docker/boot2docker

#Install Kubelet and Kubelet manifest

ENV K8S_VERSION=v1.0.3

RUN curl -fL -o $ROOTFS/usr/local/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/kubelet && \
	chmod +x $ROOTFS/usr/local/bin/kubelet

#RUN mv kubelet /usr/bin/kubelet
RUN chmod +x $ROOTFS/usr/local/bin/kubelet
RUN mkdir -p $ROOTFS/etc/kubernetes/manifests/
RUN mkdir -p $ROOTFS/etc/kubernetes/policies/
#RUN mkdir -p $ROOTFS/etc/kubernetes/certs/
RUN mkdir -p $ROOTFS/var/run/kubernetes/apiserver
RUN mkdir -p $ROOTFS/var/run/kubernetes/proxyserver
RUN mkdir -p $ROOTFS/var/run/kubernetes/kubelet
COPY kubernetes.yaml $ROOTFS/etc/kubernetes/manifests/kubernetes.yaml
COPY kubelet.kubeconfig $ROOTFS/etc/kubernetes/kubelet.kubeconfig
#COPY policy.jsonl $ROOTFS/etc/kubernetes/policies/policy.jsonl

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
RUN ln -s /usr/local/etc/init.d/kubelet $ROOTFS/etc/init.d/kubelet
COPY k8s.sh $ROOTFS/etc/rc.d/k8s.sh
RUN chmod +x $ROOTFS/etc/rc.d/k8s.sh
# Disabled to allow for activation by way of docker-machine
RUN echo "/etc/rc.d/k8s.sh" >> $ROOTFS/opt/bootscript.sh

RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]
