#!/bin/bash

set -e

### Config initiale ###
REPO_URL="https://raw.githubusercontent.com/aspitek/logmind/main"
LOGFILE="/var/log/logmind_install.log"

echo "📦 Bienvenue dans le programme d’installation LogMind 🧠"
echo "Les logs seront enregistrés dans $LOGFILE"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

check_requirements() {
  log "✅ Vérification de Docker..."
  if ! command -v docker &> /dev/null; then
    log "🚧 Docker non trouvé. Installation..."
    curl -fsSL https://get.docker.com | bash
  fi

  log "✅ Vérification de Docker Compose..."
  if ! command -v docker-compose &> /dev/null; then
    log "🚧 Docker Compose non trouvé. Installation..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
}

select_mode() {
  echo ""
  echo "Quel type de nœud voulez-vous installer ?"
  echo "1) Master (collecte + RAG + UI)"
  echo "2) Worker (collecte uniquement)"
  read -rp "Votre choix (1 ou 2) : " mode

  case "$mode" in
    1)
      NODE_TYPE="master"
      ;;
    2)
      NODE_TYPE="worker"
      ;;
    *)
      echo "❌ Choix invalide."
      exit 1
      ;;
  esac

  log "🎯 Mode sélectionné : $NODE_TYPE"
}

deploy_node() {
  COMPOSE_URL="$REPO_URL/$NODE_TYPE/docker-compose.yml"
  TMP_DIR="/tmp/logmind_$NODE_TYPE"

  mkdir -p "$TMP_DIR"
  cd "$TMP_DIR"

  log "📥 Téléchargement du docker-compose.yml pour $NODE_TYPE..."
  curl -s -O "$COMPOSE_URL"

  log "🚀 Démarrage des services..."
  docker-compose up -d

  log "✅ Déploiement terminé pour le nœud $NODE_TYPE"
}

# ======== Exécution principale =========
check_requirements
select_mode
deploy_node

log "🎉 LogMind est installé et opérationnel !"
