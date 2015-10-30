all: build cat

build:
	docker build -t boot2k8s .

cat:
	docker run --rm boot2k8s > boot2k8s.iso

run:
	VBoxManage createvm --name boot2k8s --ostype "Linux_64" --register
	VBoxManage storagectl boot2k8s --name "IDE Controller" --add ide
	VBoxManage storageattach boot2k8s --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ./boot2k8s.iso
	VBoxManage modifyvm boot2k8s --memory 1024
	VBoxManage startvm boot2k8s --type headless
	VBoxManage controlvm boot2k8s natpf1 k8s,tcp,,8080,,8080

clean:
	docker rmi boot2k8s
	rm boot2k8s.iso
