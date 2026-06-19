#!/bin/bash

# Consolida as principais informacoes para auditoria operacional.
PROJETO="Trabalho 03 - Linux, Shell Script e Cloud Computing"
TEMA="Sistema de Reservas para um Hotel"
ALUNO="Guilherme Stein Zunino Sgrott"
BASE_DIR="/app/hotel"
BACKUP_DIR="/app/backups"
LOG_DIR="/app/logs"
SITE_DIR="/var/www/html"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"

secao() {
    printf '\n===== %s =====\n' "$1"
}

status_apache() {
    if pgrep -x apache2 >/dev/null 2>&1; then echo "Apache: EM EXECUCAO"; else echo "Apache: PARADO"; fi
}

gerar_relatorio() {
    mkdir -p "$LOG_DIR"
    {
        echo "$PROJETO"
        echo "Aluno: $ALUNO"
        echo "Gerado em: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Tema: $TEMA"

        secao "ESPACO EM DISCO"
        df -h /

        secao "USO DOS DIRETORIOS"
        du -sh "$BASE_DIR" "$BACKUP_DIR" "$LOG_DIR" "$SITE_DIR" 2>/dev/null || true

        secao "SERVICO WEB"
        status_apache
        apache2 -v 2>/dev/null | head -n 1 || true

        secao "ULTIMOS BACKUPS"
        find "$BACKUP_DIR" -maxdepth 1 -type f -name '*.tar.gz' -printf '%TY-%Tm-%Td %TH:%TM %9s bytes %f\n' 2>/dev/null | sort -r | head -n 5

        secao "ULTIMOS LOGS"
        find "$LOG_DIR" -maxdepth 1 -type f -printf '%TY-%Tm-%Td %TH:%TM %f\n' 2>/dev/null | sort -r | head -n 10

        secao "ARQUIVOS PUBLICADOS"
        find "$SITE_DIR" -maxdepth 3 -type f -printf '%M %u:%g %P\n' 2>/dev/null | sort

        secao "USUARIOS E PERMISSOES"
        getent group hotel_ops || echo "Grupo hotel_ops ainda nao configurado."
        id reservas_user 2>/dev/null || echo "Usuario reservas_user ainda nao configurado."
        find "$BASE_DIR" -maxdepth 1 -printf '%M %u:%g %p\n' 2>/dev/null | sort
    } > "$RELATORIO"

    echo "[SUCESSO] Relatorio salvo em $RELATORIO"
    cat "$RELATORIO"
}

gerar_relatorio

