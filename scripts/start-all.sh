#!/bin/bash

# Nom du réseau
NETWORK_NAME="backend"

# Vérifie si le réseau existe et crée-le si nécessaire
if ! docker network ls | grep -q "$NETWORK_NAME"; then
  echo "Le réseau $NETWORK_NAME n'existe pas. Création en cours..."
  docker network create "$NETWORK_NAME"
  echo "Réseau $NETWORK_NAME créé avec succès."
else
  echo "Le réseau $NETWORK_NAME existe déjà."
fi

# Lancer le docker-compose de central (création des bases de données)
echo "Lancement du docker-compose pour docker-compose-stack"
cd ../docker-compose-stack || exit
docker-compose up -d
cd - || exit

# Attendre que PostgreSQL soit prêt
echo "Attente de la base de données PostgreSQL..."
until docker-compose exec -T postgres pg_isready -U root -d postgres; do
  echo "PostgreSQL n'est pas prêt, nouvelle tentative dans 2 secondes..."
  sleep 2
done

# Lancer les services dépendants de PostgreSQL
echo "PostgreSQL est prêt."

# Attendre que RabbitMQ soit prêt
echo "Attente de RabbitMQ..."
until docker-compose exec -T rabbitmq rabbitmqctl status; do
  echo "RabbitMQ n'est pas prêt, nouvelle tentative dans 2 secondes..."
  sleep 2
done

echo "RabbitMQ est prêt. Lancement des services..."


check_and_run() {
  local service=$1
  local service_path=$2

  if [ -d "$service_path" ]; then
    echo "Lancement du service $service..."
    cd "$service_path" || exit
    docker-compose up -d
    cd - || exit
  else
    echo "Le dossier $service_path pour $service est manquant, service ignoré."
  fi
}

# Lancer les services
check_and_run "User" "../user-service"
check_and_run "Book" "../book-service"
check_and_run "Borrowing" "../borrowing-service"
check_and_run "ApiGateway" "../api-gateway"

# Afficher un message de fin :)
echo "Tous les services ont été lancés avec succès !"
