################################################################################

SITE_COMMON_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))..

################################################################################

-include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles/help.mk
-include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles/functions.mk

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

REPO_ROOT ?= $(shell git rev-parse --show-toplevel)
COMMIT := $(shell git rev-parse --short HEAD)
PROJECT_NAME := $(notdir $(CURDIR))
PYTHON := python3
RM := rm -rf

################################################################################

$(info )
$(info PROJECT = $(PROJECT_NAME))
$(info COMMIT  = $(COMMIT))
$(info )

################################################################################

.PHONY: help clean serve dev versions

.DEFAULT_GOAL := help

################################################################################

clean:
	@## clean generated files
	$(Q) $(RM) build

################################################################################

serve:
	@## start local dev server
	$(Q) $(PYTHON) -m http.server 8000

dev: serve
	@## alias for serve

versions:
	@## print tool versions
	$(call print_tool_version,$(PYTHON),$(PYTHON))

################################################################################
