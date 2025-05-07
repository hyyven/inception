#!/bin/bash

# Répertoire de données MySQL
DATA_DIR="/var/lib/mysql"
# Fichier indicateur d'initialisation complète
INIT_FLAG="$DATA_DIR/db_init_complete"

# Fonction pour initialiser la base de données
initialize_db() {
    echo "Initialisation de la base de données..."
    
    # Démarrage initial de MariaDB pour configuration
    mysqld_safe --datadir=$DATA_DIR --skip-networking &
    
    # Attendre que le serveur soit prêt
    for i in {30..0}; do
        if mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; then
            break
        fi
        echo "En attente du démarrage du serveur... ($i)"
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "Échec du démarrage du serveur MySQL"
        exit 1
    fi
    
    echo "Serveur démarré avec succès"
    
    # Création de la base de données et configuration des utilisateurs
    echo "Création de la base de données: ${SQL_DATABASE}"
    mysql --user=root <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'localhost';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la configuration de la base de données"
        exit 1
    fi
    
    echo "Base de données configurée avec succès"
    
    # Arrêt propre pour redémarrage
    mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
    echo "Serveur arrêté pour redémarrage en mode normal"
    
    # Créer un fichier indicateur d'initialisation réussie
    touch "$INIT_FLAG"
}

# Vérifier si la base de données a déjà été initialisée
if [ ! -f "$INIT_FLAG" ]; then
    # Si le répertoire de données est vide, initialiser la base de données
    if [ -z "$(ls -A $DATA_DIR 2>/dev/null)" ] || [ ! -d "$DATA_DIR/mysql" ]; then
        echo "Premier démarrage détecté - initialisation requise"
        initialize_db
    else
        # Le répertoire existe mais le flag n'existe pas, probablement une erreur précédente
        echo "Données existantes mais sans flag d'initialisation - réinitialisation"
        initialize_db
    fi
else
    echo "Base de données déjà initialisée"
fi

# Démarrage de MariaDB en mode normal
echo "Démarrage du serveur en mode normal"
exec mysqld_safe --datadir=$DATA_DIR
