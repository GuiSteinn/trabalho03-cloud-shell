#!/bin/bash

# Coleta CPU, memoria, disco e estado do Apache com alertas operacionais.
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/07_monitoramento.log"
LIMITE_CPU="${LIMITE_CPU:-80}"
LIMITE_MEMORIA="${LIMITE_MEMORIA:-80}"
LIMITE_DISCO="${LIMITE_DISCO:-80}"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

uso_cpu() {
    local cpu1 idle1 total1 cpu2 idle2 total2 delta_total delta_idle
    read -r cpu1 _ _ _ idle1 _ _ _ _ _ < /proc/stat
    total1=$(awk '/^cpu / {for (i=2; i<=NF; i++) soma+=$i; print soma}' /proc/stat)
    sleep 1
    read -r cpu2 _ _ _ idle2 _ _ _ _ _ < /proc/stat
    total2=$(awk '/^cpu / {for (i=2; i<=NF; i++) soma+=$i; print soma}' /proc/stat)
    delta_total=$((total2 - total1))
    delta_idle=$((idle2 - idle1))
    if [ "$delta_total" -eq 0 ]; then echo 0; else echo $((100 * (delta_total - delta_idle) / delta_total)); fi
}

uso_memoria() {
    free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}'
}

uso_disco() {
    df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}'
}

avaliar_recurso() {
    local nome="$1" valor="$2" limite="$3"
    if [ "$valor" -ge "$limite" ]; then
        registrar "[ALERTA] Uso de $nome em ${valor}% (limite: ${limite}%)."
    else
        registrar "[OK] Uso de $nome em ${valor}%."
    fi
}

verificar_apache() {
    if pgrep -x apache2 >/dev/null 2>&1; then
        registrar "[OK] Apache em execucao."
    else
        registrar "[ALERTA] Apache nao esta em execucao."
    fi
}

monitorar_sistema() {
    local cpu memoria disco
    cpu=$(uso_cpu)
    memoria=$(uso_memoria)
    disco=$(uso_disco)
    registrar "Coleta operacional do Sistema de Reservas do Hotel."
    avaliar_recurso "CPU" "$cpu" "$LIMITE_CPU"
    avaliar_recurso "memoria" "$memoria" "$LIMITE_MEMORIA"
    avaliar_recurso "disco" "$disco" "$LIMITE_DISCO"
    verificar_apache
}

mkdir -p "$LOG_DIR"
monitorar_sistema

