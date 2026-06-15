#!/bin/bash

# Integra as rotinas do ambiente em um menu unico.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cabecalho() {
    clear 2>/dev/null || true
    echo "Criado por: Guilherme Stein Zunino Sgrott"
    echo "Instituicao: Unidavi"
    echo "Tema: Sistema de Reservas para um Hotel"
    echo ""
    echo "===== MENU DEVOPS CLOUD ====="
}

pausar() {
    echo
    read -r -p "Pressione Enter para continuar..." _
}

menu_processos() {
    echo "1 - Listar processos"
    echo "2 - Buscar processo"
    echo "3 - Encerrar processo por PID"
    read -r -p "Opcao: " opcao_processo
    case "$opcao_processo" in
        1) "$SCRIPT_DIR/06_processos.sh" listar ;;
        2) read -r -p "Nome: " nome; "$SCRIPT_DIR/06_processos.sh" buscar "$nome" ;;
        3) read -r -p "PID: " pid; "$SCRIPT_DIR/06_processos.sh" matar "$pid" ;;
        *) echo "Opcao invalida." ;;
    esac
}

executar_opcao() {
    case "$1" in
        1) "$SCRIPT_DIR/01_update.sh" ;;
        2) "$SCRIPT_DIR/02_apache.sh" ;;
        3) "$SCRIPT_DIR/03_estrutura.sh" ;;
        4) "$SCRIPT_DIR/04_backup.sh" ;;
        5) "$SCRIPT_DIR/05_deploy.sh" ;;
        6) menu_processos ;;
        7) "$SCRIPT_DIR/07_monitoramento.sh" ;;
        8) "$SCRIPT_DIR/08_usuarios_permissoes.sh" ;;
        9) "$SCRIPT_DIR/09_relatorio.sh" ;;
        0) echo "Encerrando menu."; exit 0 ;;
        *) echo "Opcao invalida." ;;
    esac
}

while true; do
    cabecalho
    echo "1 - Atualizar sistema"
    echo "2 - Instalar Apache"
    echo "3 - Criar estrutura do projeto"
    echo "4 - Realizar backup"
    echo "5 - Fazer deploy"
    echo "6 - Ver processos"
    echo "7 - Monitorar sistema"
    echo "8 - Configurar usuarios e permissoes"
    echo "9 - Gerar relatorio"
    echo "0 - Sair"
    read -r -p "Escolha uma opcao: " opcao
    executar_opcao "$opcao"
    pausar
done
