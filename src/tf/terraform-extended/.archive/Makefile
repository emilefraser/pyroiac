#
# Makefile
#

# Terraform

tf-install:
	@echo "==> Running script..."
	./tests/scripts/tf-install.sh

tf-prepare:
	@echo "==> Running script..."
	./tests/scripts/tf-prepare.sh

tf-fmt:
	@echo "==> Running script..."
	./tests/scripts/tf-fmt.sh

tf-init:
	@echo "==> Running script..."
	./tests/scripts/tf-init.sh

tf-plan:
	@echo "==> Running script..."
	./tests/scripts/tf-plan.sh

tf-apply:
	@echo "==> Running script..."
	./tests/scripts/tf-apply.sh

tf-destroy:
	@echo "==> Running script..."
	sh ./tasks/tf-destroy.sh

tf-version:
	@echo "==> Running script..."
	sh ./tasks/tf-version.sh

	TESTTIMEOUT=60m
TESTFILTER=
TEST?=$$(go list ./... |grep -v 'vendor'|grep -v 'utils')

default:
	@echo "==> Type make <thing> to run tasks"
	@echo
	@echo "Thing is one of:"
	@echo "docs fmt fmtcheck fumpt lint test testdeploy tfclean tools"

docs:
	@echo "==> Updating documentation..."
	find . | egrep ".md" | grep -v README.md | sort | while read f; do terrafmt fmt $$f; done
	terraform-docs -c .tfdocs-config.yml .

fmt:
	@echo "==> Fixing source code with gofmt..."
	find ./tests -name '*.go' | grep -v vendor | xargs gofmt -s -w
	@echo "==> Fixing Terraform code with terraform fmt..."
	terraform fmt -recursive
	@echo "==> Fixing embedded Terraform with terrafmt..."
	find . | egrep ".md|.tf" | grep -v README.md | sort | while read f; do terrafmt fmt $$f; done

fmtcheck:
	@echo "==> Checking source code with gofmt..."
	@sh "$(CURDIR)/scripts/gofmtcheck.sh"
	@echo "==> Checking source code with terraform fmt..."
	terraform fmt -check -recursive

fumpt:
	@echo "==> Fixing source code with Gofumpt..."
	find ./tests -name '*.go' | grep -v vendor | xargs gofumpt -w

lint:
	cd tests && golangci-lint run

test: fmtcheck
	cd tests && go test $(TEST) $(TESTARGS) -run ^Test$(TESTFILTER) -timeout=$(TESTTIMEOUT)

testdeploy: fmtcheck
	cd tests &&	TERRATEST_DEPLOY=1 go test $(TEST) $(TESTARGS) -run ^TestDeploy$(TESTFILTER) -timeout $(TESTTIMEOUT)

tfclean:
	@echo "==> Cleaning terraform files..."
	find . -type d -name '.terraform' | xargs rm -vrf
	find . -type f -name 'tfplan' | xargs rm -vf
	find . -type f -name 'terraform.tfstate*' | xargs rm -vf
	find . -type f -name '.terraform.lock.hcl' | xargs rm -vf

tools:
	go install mvdan.cc/gofumpt@latest
	go install github.com/katbyte/terrafmt@latest
	go install github.com/terraform-docs/terraform-docs@latest
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH || $$GOPATH)/bin v1.46.2

# Makefile targets are files, but we aren't using it like this,
# so have to declare PHONY targets
.PHONY: docs fmt fmtcheck fumpt lint test testdeploy tfclean tools

# Copyright 2016 Philip G. Porada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy-backend destroy destroy-target plan-destroy plan plan-target prep
VARS="variables/$(ENV)-$(REGION).tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
S3_BUCKET="$(ENV)-$(REGION)-yourCompany-terraform"
DYNAMODB_TABLE="$(ENV)-$(REGION)-yourCompany-terraform"
WORKSPACE="$(ENV)-$(REGION)"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

# Check for necessary tools
ifeq (, $(shell which aws))
	$(error "No aws in $(PATH), go to https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html, pick your OS, and follow the instructions")
endif
ifeq (, $(shell which jq))
	$(error "No jq in $(PATH), please install jq")
endif
ifeq (, $(shell which terraform))
	$(error "No terraform in $(PATH), get it from https://www.terraform.io/downloads.html")
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ENV) ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(AWS_PROFILE) ]; then \
		echo "$(BOLD)$(RED)AWS_PROFILE was not set.$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=whatever ENV=demo REGION=us-east-2 make plan\`$(RESET)"; \
		exit 1; \
	 fi
	@if [ ! -f "$(VARS)" ]; then \
		echo "$(BOLD)$(RED)Could not find variables file: $(VARS)$(RESET)"; \
		exit 1; \
	 fi

prep: set-env ## Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	@echo "$(BOLD)Verifying that the S3 bucket $(S3_BUCKET) for remote state exists$(RESET)"
	@if ! aws --profile $(AWS_PROFILE) s3api head-bucket --region $(REGION) --bucket $(S3_BUCKET) > /dev/null 2>&1 ; then \
		echo "$(BOLD)S3 bucket $(S3_BUCKET) was not found, creating new bucket with versioning enabled to store tfstate$(RESET)"; \
		aws --profile $(AWS_PROFILE) s3api create-bucket \
			--bucket $(S3_BUCKET) \
			--acl private \
			--region $(REGION) \
			--create-bucket-configuration LocationConstraint=$(REGION) > /dev/null 2>&1 ; \
		aws --profile $(AWS_PROFILE) s3api put-bucket-versioning \
			--bucket $(S3_BUCKET) \
			--versioning-configuration Status=Enabled > /dev/null 2>&1 ; \
		echo "$(BOLD)$(GREEN)S3 bucket $(S3_BUCKET) created$(RESET)"; \
	 else
		echo "$(BOLD)$(GREEN)S3 bucket $(S3_BUCKET) exists$(RESET)"; \
	 fi
	@echo "$(BOLD)Verifying that the DynamoDB table exists for remote state locking$(RESET)"
	@if ! aws --profile $(AWS_PROFILE) --region $(REGION) dynamodb describe-table --table-name $(DYNAMODB_TABLE) > /dev/null 2>&1 ; then \
		echo "$(BOLD)DynamoDB table $(DYNAMODB_TABLE) was not found, creating new DynamoDB table to maintain locks$(RESET)"; \
		aws --profile $(AWS_PROFILE) dynamodb create-table \
        	--region $(REGION) \
        	--table-name $(DYNAMODB_TABLE) \
        	--attribute-definitions AttributeName=LockID,AttributeType=S \
        	--key-schema AttributeName=LockID,KeyType=HASH \
        	--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 > /dev/null 2>&1 ; \
		echo "$(BOLD)$(GREEN)DynamoDB table $(DYNAMODB_TABLE) created$(RESET)"; \
		echo "Sleeping for 10 seconds to allow DynamoDB state to propagate through AWS"; \
		sleep 10; \
	 else
		echo "$(BOLD)$(GREEN)DynamoDB Table $(DYNAMODB_TABLE) exists$(RESET)"; \
	 fi
	@aws ec2 --profile=$(AWS_PROFILE) --region=$(REGION) describe-key-pairs | jq -r '.KeyPairs[].KeyName' | grep "$(ENV)_infra_key" > /dev/null 2>&1; \
	if [ $$? -ne 0 ]; then \
	    echo "$(BOLD)$(RED)EC2 Key Pair $(ENV)_infra_key was not found$(RESET)"; \
	    read -p '$(BOLD)Do you want to generate a new keypair? [y/Y]: $(RESET)' ANSWER && \
    	if [ "$${ANSWER}" == "y" ] || [ "$${ANSWER}" == "Y" ]; then \
	        mkdir -p ~/.ssh; \
	        ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/$(ENV)_infra_key; \
        	aws ec2 --profile=$(AWS_PROFILE) --region=$(REGION) import-key-pair --key-name "$(ENV)_infra_key" --public-key-material "file://~/.ssh/$(ENV)_infra_key.pub"; \
    	fi; \
	  else \
	      echo "$(BOLD)$(GREEN)EC2 Key Pair $(ENV)_infra_key exists$(RESET)";\
	  fi
	@echo "$(BOLD)Configuring the terraform backend$(RESET)"
	@terraform init \
		-input=false \
		-force-copy \
		-lock=true \
		-upgrade \
		-verify-plugins=true \
		-backend=true \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="region=$(REGION)" \
		-backend-config="bucket=$(S3_BUCKET)" \
		-backend-config="key=$(ENV)/$(CURRENT_FOLDER)/terraform.tfstate" \
		-backend-config="dynamodb_table=$(DYNAMODB_TABLE)"\
	    -backend-config="acl=private"
	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

plan: prep ## Show what terraform thinks it will do
	@terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)"

format: prep ## Rewrites all Terraform configuration files to a canonical format.
	@terraform fmt \
		-write=true \
		-recursive

# https://github.com/terraform-linters/tflint
lint: prep ## Check for possible errors, best practices, etc in current directory!
	@tflint

# https://github.com/liamg/tfsec
check-security: prep ## Static analysis of your terraform templates to spot potential security issues.
	@tfsec .

documentation: prep ## Generate README.md for a module
	@terraform-docs \
		markdown table \
		--sort-by-required  . > README.md

plan-target: prep ## Shows what a plan looks like for applying a specific resource
	@echo "$(YELLOW)$(BOLD)[INFO]   $(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "PLAN target: " DATA && \
		terraform plan \
			-lock=true \
			-input=true \
			-refresh=true \
			-var-file="$(VARS)" \
			-target=$$DATA

plan-destroy: prep ## Creates a destruction plan.
	@terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-var-file="$(VARS)"

apply: prep ## Have terraform do the things. This will cost money.
	@terraform apply \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)"

destroy: prep ## Destroy the things
	@terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)"

destroy-target: prep ## Destroy a specific resource. Caution though, this destroys chained resources.
	@echo "$(YELLOW)$(BOLD)[INFO] Specifically destroy a piece of Terraform data.$(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "Destroy target: " DATA && \
		terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file=$(VARS) \
		-target=$$DATA

destroy-backend: ## Destroy S3 bucket and DynamoDB table
	@if ! aws --profile $(AWS_PROFILE) dynamodb delete-table \
		--region $(REGION) \
		--table-name $(DYNAMODB_TABLE) > /dev/null 2>&1 ; then \
			echo "$(BOLD)$(RED)Unable to delete DynamoDB table $(DYNAMODB_TABLE)$(RESET)"; \
	 else
		echo "$(BOLD)$(RED)DynamoDB table $(DYNAMODB_TABLE) does not exist.$(RESET)"; \
	 fi
	@if ! aws --profile $(AWS_PROFILE) s3api delete-objects \
		--region $(REGION) \
		--bucket $(S3_BUCKET) \
		--delete "$$(aws --profile $(AWS_PROFILE) s3api list-object-versions \
						--region $(REGION) \
						--bucket $(S3_BUCKET) \
						--output=json \
						--query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')" > /dev/null 2>&1 ; then \
			echo "$(BOLD)$(RED)Unable to delete objects in S3 bucket $(S3_BUCKET)$(RESET)"; \
	 fi
	@if ! aws --profile $(AWS_PROFILE) s3api delete-objects \
		--region $(REGION) \
		--bucket $(S3_BUCKET) \
		--delete "$$(aws --profile $(AWS_PROFILE) s3api list-object-versions \
						--region $(REGION) \
						--bucket $(S3_BUCKET) \
						--output=json \
						--query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')" > /dev/null 2>&1 ; then \
			echo "$(BOLD)$(RED)Unable to delete markers in S3 bucket $(S3_BUCKET)$(RESET)"; \
	 fi
	@if ! aws --profile $(AWS_PROFILE) s3api delete-bucket \
		--region $(REGION) \
		--bucket $(S3_BUCKET) > /dev/null 2>&1 ; then \
			echo "$(BOLD)$(RED)Unable to delete S3 bucket $(S3_BUCKET) itself$(RESET)"; \
	 fi


# ------------------
# TERRAFORM-MAKEFILE
# v0.14.11
# ------------------
#
# Terraform makefile is a helper to run terraform commands
# on separate providers
#
# Copyright (C) 2017  Paul(r)B.r
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# This Makefile is maintained on Github.com.
# Please contribute upstream any changes by opening pull requests:
# https://github.com/paulRbr/terraform-makefile/pull/new/master
# Thanks! - Paul(rbr)

##
# TERRAFORM INSTALL
##
version  ?= "0.14.11"
os       ?= $(shell uname|tr A-Z a-z)
ifeq ($(shell uname -m),x86_64)
  arch   ?= "amd64"
endif
ifeq ($(shell uname -m),i686)
  arch   ?= "386"
endif
ifeq ($(shell uname -m),aarch64)
  arch   ?= "arm"
endif

##
# INTERNAL VARIABLES
##
# Read all subsquent tasks as arguments of the first task
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(args) $(RUN_ARGS):;@:)
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
landscape   := $(shell command -v landscape 2> /dev/null)
terraform   := $(shell command -v terraform 2> /dev/null)
debug       :=

##
# MAKEFILE ARGUMENTS
##
ifndef terraform
  install ?= "true"
endif
ifeq ("$(upgrade)", "true")
  install ?= "true"
endif

##
# TASKS
##
.PHONY: install
install: ## Install terraform and dependencies
ifeq ($(install),"true")
	@wget -O /usr/bin/terraform.zip https://releases.hashicorp.com/terraform/$(version)/terraform_$(version)_$(os)_$(arch).zip
	@unzip -d /usr/bin /usr/bin/terraform.zip && rm /usr/bin/terraform.zip
endif
	@terraform --version
	@bash $(dir $(mkfile_path))/terraform.sh init $(args)

.PHONY: fmt
fmt: ## Rewrites config to canonical format
	@bash $(dir $(mkfile_path))/terraform.sh fmt $(args)

.PHONY: lint
lint: ## Lint the HCL code
	@bash $(dir $(mkfile_path))/terraform.sh fmt -diff=true -check $(args) $(RUN_ARGS)

.PHONY: validate
validate: ## Basic syntax check
	@bash $(dir $(mkfile_path))/terraform.sh validate $(args) $(RUN_ARGS)

.PHONY: show
show: ## List infra resources
	@bash $(dir $(mkfile_path))/terraform.sh show $(args) $(RUN_ARGS)

.PHONY: refresh
refresh: ## Refresh infra resources
	@bash $(dir $(mkfile_path))/terraform.sh refresh $(args) $(RUN_ARGS)

.PHONY: console
console: ## Console infra resources
	@bash $(dir $(mkfile_path))/terraform.sh console $(args) $(RUN_ARGS)

.PHONY: import
import: ## Import infra resources
	@bash $(dir $(mkfile_path))/terraform.sh import $(args) $(RUN_ARGS)

.PHONY: taint
taint: ## Taint infra resources
	bash $(dir $(mkfile_path))terraform.sh taint -module=$(module) $(args) $(RUN_ARGS)

.PHONY: untaint
untaint: ## Untaint infra resources
	bash $(dir $(mkfile_path))terraform.sh untaint -module=$(module) $(args) $(RUN_ARGS)

.PHONY: workspace
workspace: ## Workspace infra resources
	bash $(dir $(mkfile_path))terraform.sh workspace $(args) $(RUN_ARGS)

.PHONY: state
state: ## Inspect or change the remote state of your resources
	@bash $(dir $(mkfile_path))/terraform.sh state $(args) $(RUN_ARGS)

.PHONY: plan
plan: dry-run
.PHONY: dry-run
dry-run: install ## Dry run resources changes
ifndef landscape
	@bash $(dir $(mkfile_path))/terraform.sh plan $(args) $(RUN_ARGS)
else
	@bash $(dir $(mkfile_path))/terraform.sh plan $(args) $(RUN_ARGS) | landscape
endif

.PHONY: apply
apply: run
.PHONY: run
run: ## Execute resources changes
	@bash $(dir $(mkfile_path))/terraform.sh apply $(args) $(RUN_ARGS)

.PHONY: destroy
destroy: ## Destroy resources
	@bash $(dir $(mkfile_path))/terraform.sh destroy $(args) $(RUN_ARGS)

.PHONY: raw
raw: ## Raw command sent to terraform
	@bash $(dir $(mkfile_path))/terraform.sh $(RUN_ARGS) $(args)

help:
	@printf "\033[32mTerraform-makefile v$(version)\033[0m\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help