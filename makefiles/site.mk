################################################################################

DEPS += make $(PYTHON) rm

SITE_COMMON_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))..

################################################################################

-include $(SITE_COMMON_ROOT)/tools/build-tools/makefiles.mk

################################################################################

.PHONY: build ci clean dev help rebuild redev serve

.DEFAULT_GOAL := help

################################################################################

build::
	@## build

ci: git-check deps-check lint build
	@## run CI checks and build

clean::
	@## clean generated files
	$(Q) $(RM) build

dev: build serve
	@## build & start local dev server

rebuild: clean
	@## clean and rebuild from scratch
	$(Q) $(MAKE) build

redev: clean
	@## clean, rebuild, and start local dev server
	$(Q) $(MAKE) dev

serve:
	@## start local dev server
	$(Q) $(PYTHON) -m http.server 8000

################################################################################
