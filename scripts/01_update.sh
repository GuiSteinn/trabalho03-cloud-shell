#!/bin/bash

# Atualiza os pacotes do Ubuntu e registra toda a operacao.
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/01_update.log"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

validar_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRO] Execute este script como root." >&2
        exit 1
    fi
}

atualizar_sistema() {
    registrar "Iniciando atualizacao do sistema do Hotel Reservas."
    export DEBIAN_FRONTEND=noninteractive
    if apt-get update >> "$LOG_FILE" 2>&1 \
        && apt-get upgrade -y \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" >> "$LOG_FILE" 2>&1; then
        registrar "[SUCESSO] Sistema atualizado corretamente."
    else
        registrar "[FALHA] Nao foi possivel atualizar todos os pacotes."
        return 1
    fi
}

mkdir -p "$LOG_DIR"
validar_root
atualizar_sistema
