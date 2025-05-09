COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)
ENV_FILE = srcs/.env
DATA_DIR_WP = /home/login/data/wordpress
DATA_DIR_DB = /home/login/data/mariadb

GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m
RESET = \033[0m

all: prepare up

prepare:
	@sudo mkdir -p $(DATA_DIR_WP)
	@sudo mkdir -p $(DATA_DIR_DB)
	@sudo chmod 755 $(DATA_DIR_WP)
	@sudo chmod 755 $(DATA_DIR_DB)
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED).env file not found. Please create the file $(ENV_FILE)$(RESET)"; \
		exit 1; \
	fi

up:
	@sudo $(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Access the application via https://localhost$(RESET)"
	@echo "$(GREEN)WordPress Admin Panel: https://localhost/wp-admin/$(RESET)"

down:
	@sudo $(DOCKER_COMPOSE) down

logs:
	@sudo $(DOCKER_COMPOSE) logs -f

relogs: re
	@sudo $(DOCKER_COMPOSE) logs -f

ps:
	@sudo $(DOCKER_COMPOSE) ps

clean: down
	@sudo docker system prune -a --force

fclean: clean
	@$(DOCKER_COMPOSE) down -v
	@sudo rm -rf /home/login/data

re: fclean all

.PHONY: all prepare build up down logs relogs ps clean fclean re