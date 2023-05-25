ANSIBLE_VIRTUALENV ?= .venv
ANSIBLE_PYTHON := $(ANSIBLE_VIRTUALENV)/bin/python3
ANSIBLE_PIP := $(ANSIBLE_PYTHON) -m pip

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

$(ANSIBLE_VIRTUALENV):
	python3 -m venv $(ANSIBLE_VIRTUALENV)
	$(ANSIBLE_PYTHON) -m pip install -U pip setuptools wheel
	$(ANSIBLE_PIP) install -U \
		'ansible-lint==6.16.1' \
		'pycodestyle==2.10.0'

.PHONY: virtualenv
virtualenv: $(ANSIBLE_VIRTUALENV) ## Create local environment

.PHONY: lint
lint: virtualenv ## Lint
	$(ANSIBLE_VIRTUALENV)/bin/ansible-lint -v molecule_qemu
	$(ANSIBLE_VIRTUALENV)/bin/pycodestyle molecule_qemu

.PHONY: clean
clean: ## Remove cache
	rm -rf $(ANSIBLE_VIRTUALENV) build dist *.egg-info
