
VM_NAME = boot2k8s
ISO_NAME = $(VM_NAME).iso

DOCKER_EXEC := $(shell which docker)
VBOX_EXEC := $(shell which VBoxManage)

ifeq ($(DOCKER_EXEC),)
$(error No docker in PATH.)
endif

ifeq ($(VBOX_EXEC),)
$(error No VBoxManage in PATH.)
endif

all: build cat

build:
	./builddeps.sh
	$(DOCKER_EXEC) build -t $(VM_NAME) .
	@echo ==============================================================
	@echo Next step: start the VM with kubernetes with this command:
	@echo make run
	@echo ==============================================================

cat:
	$(DOCKER_EXEC) run --rm $(VM_NAME) > $(ISO_NAME)

run:
	$(VBOX_EXEC) createvm --name $(VM_NAME) --ostype "Linux_64" --register
	$(VBOX_EXEC) storagectl $(VM_NAME) --name "IDE Controller" --add ide
	$(VBOX_EXEC) storageattach $(VM_NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ./$(ISO_NAME)
	$(VBOX_EXEC) modifyvm $(VM_NAME) --memory 1024 --vrde on --vrdeaddress 127.0.0.1 --vrdeport 3390 --vrdeauthtype null
	$(VBOX_EXEC) startvm $(VM_NAME) --type headless
	$(VBOX_EXEC) controlvm $(VM_NAME) natpf1 k8s,tcp,,8080,,8080
	@echo ==============================================================
	@echo The VM has been started.
	@echo Please wait few time and run this command to view your pod:
	@echo ./kubectl get pods
	@echo ==============================================================

stopvm:
	$(VBOX_EXEC) controlvm $(VM_NAME) poweroff

clean:
	$(DOCKER_EXEC) rmi $(VM_NAME)
	rm -rf $(ISO_NAME) deps

cleanvm:
	$(VBOX_EXEC) unregistervm $(VM_NAME) --delete
