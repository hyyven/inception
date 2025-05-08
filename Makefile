COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(COMPOSE_FILE)
ENV_FILE = srcs/.env
DATA_DIR_WP = data/wordpress
DATA_DIR_DB = data/mariadb

GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m
RESET = \033[0m

all: prepare up

prepare:
	@echo "$(YELLOW)Preparing environment...$(RESET)"
	@mkdir -p $(DATA_DIR_WP)
	@mkdir -p $(DATA_DIR_DB)
	@chmod 755 $(DATA_DIR_WP)
	@chmod 755 $(DATA_DIR_DB)
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Please create the file $(ENV_FILE)$(RESET)"; \
		exit 1; \
	fi

build:
	@echo "$(YELLOW)Building Docker images...$(RESET)"
	@$(DOCKER_COMPOSE) build

up:
	@echo "$(YELLOW)Starting containers...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Services are ready! Access the application via https://localhost$(RESET)"
	@echo "$(BLUE)WordPress Admin Panel: https://localhost/wp-admin/$(RESET)"

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Containers have been stopped.$(RESET)"

logs:
	@echo "$(YELLOW)Displaying logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

relogs: re
	@echo "$(GREEN)Rebuild completed. Displaying logs in real time (Ctrl+C to quit)...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

ps:
	@echo "$(YELLOW)Container status:$(RESET)"
	@$(DOCKER_COMPOSE) ps

clean: down
	@echo "$(YELLOW)Cleaning containers...$(RESET)"
	@docker system prune -a --force
	@echo "$(GREEN)Cleaning completed.$(RESET)"

fclean: clean
	@echo "$(YELLOW)Removing volumes...$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(YELLOW)Removing local volume data...$(RESET)"
	@rm -rf $(DATA_DIR_WP)/* $(DATA_DIR_DB)/*
	@echo "$(GREEN)Complete cleanup finished.$(RESET)"

re: fclean all

.PHONY: all prepare build up down logs relogs ps clean fclean re