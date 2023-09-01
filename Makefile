SHELL := /bin/bash
.PHONY: *

define terraform-apply
	. init.sh $$ \
    echo "Running: terraform apply on $(1)" && \
    cd $(1) && \
	terraform init -upgrade && \
	terraform validate && \
	terraform apply --auto-approve
endef

define terraform-destroy
	. init.sh $$ \
    echo "Running: terraform destroy on $(1)" && \
    cd $(1) && \
	terraform apply -destroy --auto-approve
endef

all: aws

destroy: aws-destroy

login:
	aws configure sso

aws:
	$(call terraform-apply, ./aws)

aws-destroy:
	$(call terraform-destroy, ./aws)

contdssh:
	$(call terraform-apply, ./contdssh)

contdssh-destroy:
	$(call terraform-destroy, ./contdssh)

ssh: rsync
	. init.sh && eval "$$(cd aws && terraform output -raw ssh_command)"

rsync:
	. init.sh && ./rsync.sh

server-build:
	docker build -t ck8sserver server
