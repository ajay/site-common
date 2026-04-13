################################################################################

SITE_COMMON_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))..

################################################################################

include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles/help.mk
include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles/functions.mk
include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles/repo.mk

################################################################################

SHELL := bash

MAKEFLAGS += -rR                        # do not use make's built-in rules and variables
MAKEFLAGS += -k                         # keep going on errors
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-print-directory

################################################################################

verbose ?= true

ifeq ($(verbose), true)
	Q :=
else
	Q := @
endif

################################################################################

COMMIT := $(shell git rev-parse --short HEAD)
PROJECT_NAME := $(notdir $(CURDIR))
PYTHON := python3
REPO_ROOT ?= $(shell git rev-parse --show-toplevel)
RM := rm -rf

################################################################################

$(info )
$(info PROJECT = $(PROJECT_NAME))
$(info COMMIT  = $(COMMIT))
$(info )

################################################################################

ifeq ($(shell uname -s),Darwin)
	OS := mac
else
	OS := $(shell lsb_release -is | tr A-Z a-z)
endif

################################################################################

.PHONY: help ci clean dev install-deps lint lint-html lint-json serve versions

.DEFAULT_GOAL := help

################################################################################

ci: repo-check lint
	@## run CI checks and build
	$(Q) if make -n build 2>/dev/null; then \
		$(MAKE) build; \
	fi

clean:
	@## clean generated files
	$(Q) $(RM) build

dev: serve
	@## alias for serve

install-deps:
	@## install dependencies
	$(SITE_COMMON_ROOT)/tools/deps/os/$(OS).sh

lint: lint-html lint-json
	@## run all linters

lint-html:
	@## lint HTML files
	$(Q) find $(REPO_ROOT) -name '*.html' -not -path '*/.git/*' -not -path '*/build/*' | xargs htmlhint

lint-json:
	@## lint JSON files
	$(Q) find $(REPO_ROOT) -name '*.json' -not -path '*/.git/*' -not -path '*/build/*' -not -path '*/.claude/*' | while read f; do $(PYTHON) -m json.tool "$$f" > /dev/null || exit 1; done

serve:
	@## start local dev server
	$(Q) $(PYTHON) -m http.server 8000

versions:
	@## print tool versions
	$(call print_tool_version,$(PYTHON),$(PYTHON))

################################################################################
