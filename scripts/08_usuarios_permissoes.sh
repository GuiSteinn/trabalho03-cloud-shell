#!/bin/bash

# Configura identidade e acessos operacionais sem permissoes abertas.
GRUPO="hotel_ops"
USUARIO="reservas_user"
BASE_DIR="/app/hotel"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/08_usuarios_permissoes.log"

registrar() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

validar_root() {
    if [ "$(id -u)" -ne 0 ]; then
        registrar "[ERRO] Execute como root para criar usuarios e alterar proprietarios."
        exit 1
    fi
}

criar_identidades() {
    getent group "$GRUPO" >/dev/null || groupadd --system "$GRUPO"
    id "$USUARIO" >/dev/null 2>&1 || useradd --system --gid "$GRUPO" --home-dir "$BASE_DIR" --shell /usr/sbin/nologin "$USUARIO"
    usermod -aG "$GRUPO" www-data
    registrar "Grupo $GRUPO e usuario $USUARIO disponiveis."
}

aplicar_permissoes() {
    mkdir -p "$BASE_DIR"/{reservas,hospedes,quartos,dados,logs,publicacao,backups}
    chown -R "$USUARIO:$GRUPO" "$BASE_DIR"
    chmod 2750 "$BASE_DIR"
    chmod 2770 "$BASE_DIR"/{reservas,hospedes,quartos,dados,logs,backups}
    chmod 2750 "$BASE_DIR/publicacao"
    registrar "chown aplicado para $USUARIO:$GRUPO."
    registrar "chmod 2750/2770 aplicado; nenhum diretorio usa permissao 777."
}

exibir_resultado() {
    id "$USUARIO" | tee -a "$LOG_FILE"
    find "$BASE_DIR" -maxdepth 1 -printf '%M %u:%g %p\n' | sort | tee -a "$LOG_FILE"
}

mkdir -p "$LOG_DIR"
validar_root
criar_identidades
aplicar_permissoes
exibir_resultado
registrar "[SUCESSO] Usuarios, grupo e permissoes configurados."

