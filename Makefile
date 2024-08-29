#!/usr/bin/env make

.PHONY: run_website install_kind install_kubectl create_kind_cluster \
	create_docker_registry connect_registry_to_kind_network \
	connect_registry_to_kind create_kind_cluster_with_registry

run_website:
	docker build -t explorecalifornia.com . && \
		docker run -p 80:80 -d --name explorecalifornia.com --rm explorecalifornia.com

install_kind:
	brew install kind || true;
	kind --version

install_kubectl:
	brew install kubectl || true;

create_kind_cluster_without_registry: create_docker_registry
	kind create cluster --image=kindest/node:v1.21.12 --name explorecalifornia.com --config ./kind_config.yaml || true
	kubectl get nodes

create_docker_registry:
	if ! docker ps | grep -q 'local-registry'; \
	then docker run -d -p 5000:5000 --name local-registry --restart=always registry:2; \
	else echo "---> local-registry is already running. There's nothing to do here."; \
	fi


connect_registry_to_kind_network:
	docker network connect kind local-registry || true;

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f ./kind_configmap.yaml;



create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster_without_registry && $(MAKE) connect_registry_to_kind


delete_kind_cluster: delete_docker_registry
	kind delete cluster --name explorecalifornia.com

delete_docker_registry:
	docker stop local-registry && docker rm local-registry