STACK ?= infra/stacks/{{cookiecutter.stack_name}}
ENV ?= dev

fmt:
	tofu -chdir=$(STACK) fmt -recursive

plan:
	tofu -chdir=$(STACK) init -input=false
	tofu -chdir=$(STACK) plan -input=false -no-color -var-file=../../../env/$(ENV).tfvars

apply:
	@if [ "$(ENV)" = "prod" ]; then echo "Prod apply is CI-only. Use workflow_dispatch with environment=prod."; exit 1; fi
	tofu -chdir=$(STACK) init -input=false
	tofu -chdir=$(STACK) apply -input=false -no-color -var-file=../../../env/$(ENV).tfvars
