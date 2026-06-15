#!/bin/bash

# Gera um pacote compactado da operacao do hotel e do site publicado.
ORIGEM="/app/hotel"
SITE="/var/www/html"
DESTINO="/app/backups"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/04_backup.log"
DATA_HORA="$(date '+%Y-%m-%d_%H-%M-%S')"
ARQUIVO="$DESTINO/backup_hotel_reservas_${DATA_HORA}.tar.gz"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

validar_origem() {
    if [ ! -d "$ORIGEM" ]; then
        registrar "[ERRO] Diretorio de origem inexistente: $ORIGEM"
        exit 1
    fi
}

realizar_backup() {
    mkdir -p "$DESTINO" "$LOG_DIR"
    registrar "Iniciando backup de $ORIGEM e $SITE."

    if tar -czf "$ARQUIVO" -C / app/hotel var/www/html >> "$LOG_FILE" 2>&1 && [ -s "$ARQUIVO" ]; then
        registrar "[SUCESSO] Backup criado: $ARQUIVO ($(du -h "$ARQUIVO" | cut -f1))."
    else
        registrar "[FALHA] O arquivo de backup nao foi criado corretamente."
        rm -f "$ARQUIVO"
        return 1
    fi
}

mkdir -p "$LOG_DIR"
validar_origem
realizar_backup

