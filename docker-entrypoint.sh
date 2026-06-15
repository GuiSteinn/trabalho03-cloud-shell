#!/bin/bash
set -e

# Prepara os diretorios montados e publica o site antes de iniciar o Apache.
mkdir -p /app/backups /app/logs /app/hotel/dados
chmod +x /app/scripts/*.sh
/app/scripts/03_estrutura.sh
/app/scripts/05_deploy.sh

exec apachectl -D FOREGROUND

