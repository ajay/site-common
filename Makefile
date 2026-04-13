################################################################################

# Copied from build-tools repo.mk reference implementation.
# https://github.com/ajay/build-tools/blob/main/makefiles/repo.mk
# Keep in sync with the reference when updating.

REPO_ROOT := $(shell git rev-parse --show-toplevel)

repo-init:
	@## initialize git submodules
	git submodule sync --recursive
	git submodule update --init --recursive

ifneq ($(MAKECMDGOALS),repo-init)
ifneq (,$(shell git submodule status --recursive 2>/dev/null | grep '^-'))
$(error ERROR: git submodules not initialized; run `make repo-init`)
endif
endif

################################################################################

-include $(REPO_ROOT)/tools/build-tools/makefiles/help.mk
-include $(REPO_ROOT)/tools/build-tools/makefiles/repo.mk

################################################################################

PYTHON := python3
SHELL := bash

MAKEFLAGS += -rR
MAKEFLAGS += -k
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

ifeq ($(shell uname -s),Darwin)
	OS := mac
else
	OS := $(shell lsb_release -is | tr A-Z a-z)
endif

################################################################################

.DEFAULT_GOAL := help

ci: repo-check lint
	@## run CI checks

install-deps:
	@## install dependencies
	tools/deps/os/$(OS).sh

lint: lint-html lint-json
	@## run all linters

lint-html:
	@## lint HTML files
	find $(REPO_ROOT) -name '*.html' -not -path '*/.git/*' -not -path '*/build/*' | xargs htmlhint

lint-json:
	@## lint JSON files
	find $(REPO_ROOT) -name '*.json' -not -path '*/.git/*' -not -path '*/build/*' -not -path '*/.claude/*' | while read f; do $(PYTHON) -m json.tool "$$f" > /dev/null || exit 1; done

################################################################################
