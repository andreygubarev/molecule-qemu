MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: lint
lint: ## Lint
	ansible-lint -v molecule_qemu
	pycodestyle molecule_qemu

.PHONY: test
test: ## Test
	pip install -e .
	cd tests && molecule test

.PHONY: test-%
test-%:
	pip install -e .
	cd tests && molecule test -s $*

.PHONY: test-network
test-network: test-network-shared test-network-user  ## Test network

.PHONY: test-os-debian
test-os-debian: test-os-debian-bullseye test-os-debian-bookworm  ## Test Debian OS

.PHONY: test-os-ubuntu
test-os-ubuntu: test-os-ubuntu-focal test-os-ubuntu-jammy  ## Test Ubuntu OS

.PHONY: test-os
test-os: test-os-debian test-os-ubuntu  ## Test OS

.PHONY: test-platform
test-platform: test-platform-amd64 test-platform-arm64  ## Test platform

.PHONY: clean
clean: ## Remove cache
	rm -rf $(MAKEFILE_DIR)/.venv build dist *.egg-info
