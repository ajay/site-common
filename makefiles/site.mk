################################################################################

DEPS += make $(PYTHON) rm

SITE_COMMON_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))..

################################################################################

-include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles.mk

################################################################################

.PHONY: help ci clean dev serve

.DEFAULT_GOAL := help

################################################################################

ci: git-check deps-check lint
	@## run CI checks and build
	$(Q) if make -n build 2>/dev/null; then \
		$(MAKE) build; \
	fi

clean::
	@## clean generated files
	$(Q) $(RM) build

dev: serve
	@## alias for serve

serve:
	@## start local dev server
	$(Q) $(PYTHON) -m http.server 8000

################################################################################
