BICEP_FILE ?= infra/bicep/main.bicep
ENV ?= dev
RG_DEV ?= {{cookiecutter.azure_resource_group_dev}}
RG_PROD ?= {{cookiecutter.azure_resource_group_prod}}

build:
	az bicep build --file $(BICEP_FILE)

lint:
	az bicep lint --file $(BICEP_FILE)

whatif:
	@RG=$$([ "$(ENV)" = "prod" ] && echo "$(RG_PROD)" || echo "$(RG_DEV)"); \
	az deployment group what-if \
		--resource-group $$RG \
		--template-file $(BICEP_FILE) \
		--parameters env/$(ENV).bicepparam

deploy:
	@if [ "$(ENV)" = "prod" ]; then echo "Prod deploy is CI-only. Use workflow_dispatch with environment=prod."; exit 1; fi
	@RG=$$([ "$(ENV)" = "prod" ] && echo "$(RG_PROD)" || echo "$(RG_DEV)"); \
	az deployment group create \
		--resource-group $$RG \
		--template-file $(BICEP_FILE) \
		--parameters env/$(ENV).bicepparam
