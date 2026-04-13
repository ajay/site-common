################################################################################

# Copied from build-tools repo.mk reference implementation.
# https://github.com/ajay/build-tools/blob/main/makefiles/repo.mk
# Keep in sync with the reference when updating.

REPO_ROOT := $(shell git rev-parse --show-toplevel)

# Path to repo.mk — used as existence check for whether submodules
# are initialized. Update this path to match your submodule layout.
REPO_INIT_CHECK := $(REPO_ROOT)/tools/build-tools/makefiles/repo.mk

repo-init:
	@## initialize git submodules
	git submodule sync --recursive
	git submodule update --init --recursive

ifneq ($(MAKECMDGOALS),repo-init)
ifeq (,$(wildcard $(REPO_INIT_CHECK)))
$(error ERROR: git submodules not initialized; run `make repo-init`)
endif
endif

################################################################################

-include $(REPO_ROOT)/tools/build-tools/makefiles/help.mk
-include $(REPO_ROOT)/tools/build-tools/makefiles/repo.mk

################################################################################

SHELL := bash

MAKEFLAGS += -rR
MAKEFLAGS += -k
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

.DEFAULT_GOAL := help

ci: repo-check
	@## run CI checks

################################################################################
