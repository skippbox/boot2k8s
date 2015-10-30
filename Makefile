all: build cat

build:
	docker build -t boot2k8s .
cat:
	docker run --rm boot2k8s > boot2k8s.iso
clean:
	docker rmi boot2k8s
	rm boot2k8s.iso
