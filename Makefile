MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
VIRTUALENV_VENV ?= $(MAKEFILE_DIR)/.venv
VIRTUALENV_PYTHON := $(VIRTUALENV_VENV)/bin/python3
VIRTUALENV_PIP := $(VIRTUALENV_PYTHON) -m pip
VIRTUALENV_MOLECULE := $(VIRTUALENV_VENV)/bin/molecule

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

$(VIRTUALENV_VENV):
	python3 -m venv $(VIRTUALENV_VENV)
	$(VIRTUALENV_PIP) install \
		'ansible-lint==6.16.1' \
		'pycodestyle==2.10.0'

.PHONY: virtualenv
virtualenv: $(VIRTUALENV_VENV) ## Create local environment

.PHONY: lint
lint: virtualenv ## Lint
	$(VIRTUALENV_VENV)/bin/ansible-lint -v molecule_qemu
	$(VIRTUALENV_VENV)/bin/pycodestyle molecule_qemu

.PHONY: test
test: virtualenv ## Test
	$(VIRTUALENV_PIP) install -e .
	cd tests && $(VIRTUALENV_MOLECULE) test -s default

.PHONY: test-all
test-all: virtualenv ## Test
	$(VIRTUALENV_PIP) install -e .
	cd tests && \
		$(VIRTUALENV_MOLECULE) destroy || true && \
		$(VIRTUALENV_MOLECULE) reset && \
		$(VIRTUALENV_MOLECULE) test -s default && \
		$(VIRTUALENV_MOLECULE) test -s user && \
		$(VIRTUALENV_MOLECULE) test -s vmnet-shared

.PHONY: clean
clean: ## Remove cache
	rm -rf $(VIRTUALENV_VENV) build dist *.egg-info
