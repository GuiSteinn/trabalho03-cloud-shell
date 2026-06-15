#!/bin/bash

# Instala, inicia e valida o servidor Apache do portal do hotel.
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/02_apache.log"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

validar_root() {
    if [ "$(id -u)" -ne 0 ]; then
        registrar "[ERRO] A instalacao do Apache exige usuario root."
        exit 1
    fi
}

instalar_apache() {
    if command -v apache2 >/dev/null 2>&1; then
        registrar "Apache ja esta instalado."
        return 0
    fi

    registrar "Instalando Apache."
    apt-get update >> "$LOG_FILE" 2>&1
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 >> "$LOG_FILE" 2>&1
}

verificar_apache() {
    if ! pgrep -x apache2 >/dev/null 2>&1; then
        registrar "Apache parado; tentando iniciar."
        apachectl start >> "$LOG_FILE" 2>&1 || true
    fi

    if pgrep -x apache2 >/dev/null 2>&1; then
        registrar "[OK] Apache em execucao."
    else
        registrar "[ALERTA] Apache instalado, mas nao esta em execucao."
        return 1
    fi
}

versao_apache() {
    registrar "Versao instalada: $(apache2 -v | head -n 1)"
}

mkdir -p "$LOG_DIR"
validar_root
instalar_apache
versao_apache
verificar_apache

