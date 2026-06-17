.PHONY: help login setup dev dev-down prod prod-pull prod-down logs ps

# ===== CONFIG =====
COMPOSE_BASE = -f docker-compose.yml
COMPOSE_DEV = -f docker-compose.dev.yml
COMPOSE_PROD = -f docker-compose.prod.yml

ENV_FILE = --env-file versions.env

AWS_ACCOUNT_ID := 719030484884
AWS_REGION := eu-north-1

.DEFAULT_GOAL := help

help: ## Show available targets
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_.-]+:.*##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  %-22s %s\n", $$1, $$2}'
	@echo ""
	@echo "Compose: base=$(COMPOSE_BASE) dev=$(COMPOSE_DEV) prod=$(COMPOSE_PROD)"

# ==== ECR ====
login: ## Login to ECR for pulling/pushing images
	@echo "Initiating ECR login..."
	aws ecr get-login-password --region $(AWS_REGION) \
		| docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com


# ===== SETUP =====
setup: ## Copy example env files into place
	cp versions.env.example versions.env || true
	@for file in envs/*.env.example; do \
		[ -e "$$file" ] || continue; \
		cp "$$file" "$${file%.example}"; \
	done
	@echo "Setup done. Edit env files if needed."

# ===== DEV =====
dev: ## Start full dev stack
	docker compose $(ENV_FILE) $(COMPOSE_BASE) $(COMPOSE_DEV) up

dev-down: ## Stop dev stack
	docker compose $(ENV_FILE) $(COMPOSE_BASE) $(COMPOSE_DEV) down

# ===== PROD =====
prod: ## Start production stack (detached)
	docker compose $(ENV_FILE) $(COMPOSE_BASE) $(COMPOSE_PROD) up -d

prod-pull: ## Pull latest production images
	docker compose $(ENV_FILE) $(COMPOSE_BASE) $(COMPOSE_PROD) pull

prod-down: ## Stop production stack
	docker compose $(ENV_FILE) $(COMPOSE_BASE) $(COMPOSE_PROD) down

# ===== UTILS =====
logs: ## Tail logs for base compose stack
	docker compose $(ENV_FILE) $(COMPOSE_BASE) logs -f

ps: ## Show status of base compose stack
	docker compose $(ENV_FILE) $(COMPOSE_BASE) ps