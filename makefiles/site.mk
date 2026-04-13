################################################################################

SITE_COMMON_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))..

################################################################################

-include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles.mk

################################################################################

verbose ?= true

ifeq ($(verbose), true)
	Q :=
else
	Q := @
endif

################################################################################

.PHONY: help ci clean dev install-deps serve versions

.DEFAULT_GOAL := help

################################################################################

ci: repo-check lint
	@## run CI checks and build
	$(Q) if make -n build 2>/dev/null; then \
		$(MAKE) build; \
	fi

clean::
	@## clean generated files
	$(Q) $(RM) build

dev: serve
	@## alias for serve

install-deps:
	@## install dependencies
	$(SITE_COMMON_ROOT)/tools/deps/os/$(OS).sh

serve:
	@## start local dev server
	$(Q) $(PYTHON) -m http.server 8000

versions::
	@## print tool versions
	$(call print_tool_version,$(PYTHON),$(PYTHON))

################################################################################
