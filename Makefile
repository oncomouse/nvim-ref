SHELL := /bin/bash
.ONESHELL:
# .SHELLFLAGS := -eu -o pipefail

# ifeq ($(origin .RECIPEPREFIX), undefined)
# 	$(error Please use GNU Make 4.0 or later which supports .RECIPEPREFIX)
# endif
# .RECIPEPREFIX = >
.DELETE_ON_ERROR:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

VUSTED ?= vusted

REPO_ROOT:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TEST_ROOT:=$(REPO_ROOT)/tests

TEST_DEPS:=$(TEST_ROOT)/.test-deps

LUA_TESTS:=$(wildcard tests/spec/*_spec.lua)

LUA_RUNTIMES:=$(shell find lua/ -name '*.lua')

LUA_RUNTIME_DIRS:=$(shell find lua/ -type d)

REPO_LUA_DIR := $(REPO_ROOT)/lua
REPO_LUA_PATH := $(REPO_FNL_DIR)/?.lua;$(REPO_FNL_DIR)/?/init.lua

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@echo
	@echo 'Usage:'
	@echo '  make <target> [flags...]'
	@echo
	@echo 'Targets:'
	@egrep -h '^\S+: .*## \S+' $(MAKEFILE_LIST) | sed 's/: .*##/:/' | column -t -c 2 -s ':' | sed 's/^/  /'
	@echo

.PHONY: test
test:
	@RTP_DEP="$(REPO_ROOT)" \
		VUSTED_ARGS="--headless --clean -u $(TEST_ROOT)/init.lua" \
		$(VUSTED) \
		--shuffle \
		--output=utfTerminal \
		./tests

