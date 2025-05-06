# Makefile pour le projet Inception avec Docker Compose

# Déclaration des variables
COMPOSE_FILE = srcs/docker-compose.yml
DOCKER_COMPOSE = docker-compose -f $(COMPOSE_FILE)
ENV_FILE = srcs/.env
DATA_DIR_WP = data/wordpress
DATA_DIR_DB = data/mariadb

# Couleurs pour améliorer la lisibilité
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
RESET = \033[0m

# Cible par défaut
all: prepare up

# Préparation de l'environnement
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

# Construction des images Docker
build:
	@echo "$(YELLOW)Construction des images Docker...$(RESET)"
	@$(DOCKER_COMPOSE) build

# Démarrage des conteneurs en arrière-plan
up:
	@echo "$(YELLOW)Démarrage des conteneurs...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Les services sont prêts ! Accès à l'application via https://localhost$(RESET)"

# Arrêt des conteneurs
down:
	@echo "$(YELLOW)Arrêt des conteneurs...$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Les conteneurs ont été arrêtés.$(RESET)"

# Afficher les logs des conteneurs
logs:
	@echo "$(YELLOW)Affichage des logs...$(RESET)"
	@$(DOCKER_COMPOSE) logs

# Afficher l'état des conteneurs
ps:
	@echo "$(YELLOW)État des conteneurs:$(RESET)"
	@$(DOCKER_COMPOSE) ps

# Nettoyage : arrêt des conteneurs
clean: down
	@echo "$(YELLOW)Nettoyage des conteneurs...$(RESET)"
	@docker system prune -a --force
	@echo "$(GREEN)Nettoyage terminé.$(RESET)"

# Nettoyage complet : suppression des volumes et des images
fclean: clean
	@echo "$(YELLOW)Suppression des volumes...$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(YELLOW)Suppression des données des volumes locaux...$(RESET)"
	@rm -rf $(DATA_DIR_WP)/* $(DATA_DIR_DB)/*
	@echo "$(GREEN)Nettoyage complet terminé.$(RESET)"

# Reconstruction complète
re: fclean all

# Cibles qui n'existent pas en tant que fichiers
.PHONY: all prepare build up down logs ps clean fclean re