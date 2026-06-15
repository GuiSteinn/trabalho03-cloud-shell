#!/bin/bash

# Cria a estrutura operacional tematica do Sistema de Reservas do Hotel.
BASE_DIR="/app/hotel"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/03_estrutura.log"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

remover_estrutura_antiga() {
    local antiga="$BASE_DIR/temporario"
    if [ -d "$antiga" ] && [[ "$antiga" == /app/hotel/* ]]; then
        rm -rf -- "$antiga"
        registrar "Estrutura temporaria antiga removida com seguranca."
    fi
}

criar_estrutura() {
    local diretorios=(reservas hospedes quartos dados logs publicacao backups)
    local diretorio

    for diretorio in "${diretorios[@]}"; do
        mkdir -p "$BASE_DIR/$diretorio"
        registrar "Diretorio preparado: $BASE_DIR/$diretorio"
    done

    touch "$BASE_DIR/reservas/reservas_pendentes.csv"
    touch "$BASE_DIR/hospedes/hospedes_ativos.csv"
    touch "$BASE_DIR/quartos/status_quartos.csv"
    printf 'ambiente=hotel-reservas\ncriado_em=%s\n' "$(date '+%Y-%m-%d %H:%M:%S')" > "$BASE_DIR/dados/ambiente.conf"
    registrar "Arquivos operacionais iniciais criados."
}

mkdir -p "$LOG_DIR"
remover_estrutura_antiga
criar_estrutura
registrar "[SUCESSO] Estrutura tematica do hotel pronta."

