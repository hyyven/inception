COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(COMPOSE_FILE)
ENV_FILE = srcs/.env
DATA_DIR_WP = data/wordpress
DATA_DIR_DB = data/mariadb

GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
RESET = \033[0m

all: prepare up

prepare:
	@echo "$(YELLOW)Préparation de l'environnement...$(RESET)"
	@mkdir -p $(DATA_DIR_WP)
	@mkdir -p $(DATA_DIR_DB)
	@chmod 755 $(DATA_DIR_WP)
	@chmod 755 $(DATA_DIR_DB)
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)Fichier .env non trouvé. Veuillez créer le fichier $(ENV_FILE)$(RESET)"; \
		exit 1; \
	fi

build:
	@echo "$(YELLOW)Construction des images Docker...$(RESET)"
	@$(DOCKER_COMPOSE) build

up:
	@echo "$(YELLOW)Démarrage des conteneurs...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Les services sont prêts ! Accès à l'application via https://localhost$(RESET)"

down:
	@echo "$(YELLOW)Arrêt des conteneurs...$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Les conteneurs ont été arrêtés.$(RESET)"

logs:
	@echo "$(YELLOW)Affichage des logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

relogs: re
	@echo "$(GREEN)Reconstruction terminée. Affichage des logs en temps réel (Ctrl+C pour quitter)...$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

ps:
	@echo "$(YELLOW)État des conteneurs:$(RESET)"
	@$(DOCKER_COMPOSE) ps

clean: down
	@echo "$(YELLOW)Nettoyage des conteneurs...$(RESET)"
	@docker system prune -a --force
	@echo "$(GREEN)Nettoyage terminé.$(RESET)"

fclean: clean
	@echo "$(YELLOW)Suppression des volumes...$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(YELLOW)Suppression des données des volumes locaux...$(RESET)"
	@rm -rf $(DATA_DIR_WP)/* $(DATA_DIR_DB)/*
	@echo "$(GREEN)Nettoyage complet terminé.$(RESET)"

re: fclean all

.PHONY: all prepare build up down logs relogs ps clean fclean re