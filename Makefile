SHELL := bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# ---- Config (override like: make DO_ENV=environments/do/dev do-up) ----
DO_ENV ?= environments/do/dev
DO_TOKEN_VAR ?= DIGITALOCEAN_TOKEN

OTEL_NAMESPACE ?= otel-demo
OTEL_RELEASE ?= my-otel-demo

# ---- Helpers ----
.PHONY: help
help:
	@echo "Targets:"
	@echo "  make precommit     - run pre-commit hooks on all files"
	@echo "  make check         - verify required tools exist"
	@echo "  make fmt           - format tofu/terraform files"
	@echo "  make lint          - run tflint (if installed)"
	@echo "  make do-up         - provision DOKS via OpenTofu"
	@echo "  make do-deploy     - deploy OTel demo via Helm script"
	@echo "  make do-test       - run smoke test"
	@echo "  make do-status     - show cluster + otel namespace status"
	@echo "  make do-down       - destroy DOKS via OpenTofu"
	@echo ""
	@echo "Vars:"
	@echo "  DO_ENV=$(DO_ENV)"
	@echo "  OTEL_NAMESPACE=$(OTEL_NAMESPACE)"
	@echo "  OTEL_RELEASE=$(OTEL_RELEASE)"
	@echo "  DO_TOKEN_VAR=$(DO_TOKEN_VAR) (expects env var with DO API token)"
	@echo ""
	@echo "Examples:"
	@echo "  $(MAKE) check do-up do-deploy do-test"
	@echo "  $(MAKE) do-down"

.PHONY: precommit
precommit:
	@echo "Running all pre-commit hooks on all files..."
	@pre-commit run --all-files

.PHONY: check
check:
	@./scripts/check_deps.sh
	@if [[ -z "$${$(DO_TOKEN_VAR):-}" ]]; then \
	  echo "WARN: $$$(DO_TOKEN_VAR) is not set. doctl may not be authenticated yet."; \
	fi

.PHONY: fmt
fmt:
	@echo "==> Formatting tofu files"
	tofu fmt -recursive

.PHONY: lint
lint:
	@echo "==> Linting with tflint (if installed)"
	if command -v tflint >/dev/null 2>&1; then \
	  tflint --chdir=modules/do-doks; \
	  tflint --chdir=$(DO_ENV); \
	else \
	  echo "tflint not installed; skipping."; \
	fi

# ---- DigitalOcean flow ----
.PHONY: do-up
do-up: check
	@echo "==> Provisioning DOKS (env: $(DO_ENV))"
	cd $(DO_ENV)
	tofu init
	tofu apply -var "do_token=$${$(DO_TOKEN_VAR)}"

.PHONY: do-down
do-down: check
	@echo "==> Destroying DOKS (env: $(DO_ENV))"
	cd $(DO_ENV)
	tofu init
	tofu destroy -var "do_token=$${$(DO_TOKEN_VAR)}"

.PHONY: do-deploy
do-deploy: check
	@echo "==> Deploying OTel demo via Helm script"
	./scripts/deploy-otel-demo.sh --namespace $(OTEL_NAMESPACE) --release $(OTEL_RELEASE)

.PHONY: do-test
do-test: check
	@echo "==> Running smoke test"
	./scripts/smoke-test.sh

.PHONY: do-status
do-status: check
	@echo "==> kubectl context"
	kubectl config current-context || true
	@echo ""
	@echo "==> nodes"
	kubectl get nodes -o wide || true
	@echo ""
	@echo "==> otel namespace pods"
	kubectl -n $(OTEL_NAMESPACE) get pods -o wide || true
	@echo ""
	@echo "==> otel namespace services"
	kubectl -n $(OTEL_NAMESPACE) get svc || true
