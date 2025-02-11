SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL = all

.PHONY: help
help: # see https://diamantidis.github.io/tips/2020/07/01/list-makefile-targets
	@grep -hE '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1|\3/p' \
	| column -t  -s '|'

.PHONY: clean
clean:
	$(RM) -rf coverage/

.PHONY: all
all: lint test run

.PHONY: run
run: run.sh ## Runs sample game
	./run.sh

.PHONY: lint
lint: Makefile *.sh ## Lint with shellcheck
	shellcheck -S style *.sh
	checkmake Makefile

.PHONY: pedantic-lint
pedantic-lint: *.sh ## Lint with shellcheck - pedantic mode
	shellcheck -o all -S style *.sh

.PHONY: test
test: *.bats ## Runs all tests
	bats --jobs $$(nproc) $^

.PHONY: coverage
coverage: *.bats ## Runs tests with coverage
	kcov --bash-dont-parse-binary-dir --include-path=. coverage bats $^
	jq -r '.percent_covered' < $$(find coverage -name coverage.json)

.PHONY: time
time: ## Run sample multiple times and print timings
	hyperfine ./run.sh
