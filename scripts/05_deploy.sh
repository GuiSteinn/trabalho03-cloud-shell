#!/bin/bash

# Publica no Apache o site estatico adaptado do Trabalho 02.
ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/05_deploy.log"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

validar_diretorios() {
    if [ ! -f "$ORIGEM/index.html" ]; then
        registrar "[ERRO] O arquivo source/index.html nao foi encontrado."
        exit 1
    fi
    if [[ "$DESTINO" != "/var/www/html" ]]; then
        registrar "[ERRO] Destino de deploy nao autorizado: $DESTINO"
        exit 1
    fi
}

realizar_deploy() {
    mkdir -p "$DESTINO" "$LOG_DIR"
    registrar "Limpando publicacao anterior."
    find "$DESTINO" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
    cp -a "$ORIGEM/." "$DESTINO/"
    chown -R www-data:www-data "$DESTINO"
    find "$DESTINO" -type d -exec chmod 755 {} +
    find "$DESTINO" -type f -exec chmod 644 {} +

    registrar "Arquivos publicados:"
    find "$DESTINO" -type f -printf '%P\n' | sort | tee -a "$LOG_FILE"

    if [ -f "$DESTINO/index.html" ]; then
        registrar "[SUCESSO] Deploy do portal de reservas concluido."
    else
        registrar "[FALHA] index.html ausente apos o deploy."
        return 1
    fi
}

validar_diretorios
realizar_deploy

