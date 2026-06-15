#!/bin/bash

# Lista, pesquisa e encerra processos de forma controlada.

mostrar_uso() {
    echo "Uso:"
    echo "  $0 listar"
    echo "  $0 buscar <nome>"
    echo "  $0 matar <PID>"
}

listar_processos() {
    echo "=== Processos ativos no ambiente do hotel ==="
    ps aux --sort=-%cpu | head -n 16
}

buscar_processo() {
    local nome="$1"
    if [ -z "$nome" ]; then
        echo "[ERRO] Informe o nome do processo." >&2
        return 1
    fi
    echo "=== Resultado da busca por: $nome ==="
    pgrep -af -- "$nome" || echo "Nenhum processo encontrado."
}

matar_processo() {
    local pid="$1"
    if [ -z "$pid" ]; then
        echo "[BLOQUEADO] Nenhum PID informado. O processo nao sera encerrado." >&2
        return 1
    fi
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "[ERRO] O PID deve conter somente numeros." >&2
        return 1
    fi
    if [ "$pid" -eq 1 ] || [ "$pid" -eq "$$" ]; then
        echo "[BLOQUEADO] PID protegido para evitar a parada do container ou do script." >&2
        return 1
    fi
    if ! kill -0 "$pid" 2>/dev/null; then
        echo "[ERRO] PID $pid nao existe ou nao pode ser acessado." >&2
        return 1
    fi

    echo "Encerrando o PID $pid com SIGTERM."
    kill -TERM "$pid"
    echo "[OK] Sinal enviado. Confirme o resultado com: ps -p $pid"
}

case "${1:-}" in
    listar) listar_processos ;;
    buscar) buscar_processo "${2:-}" ;;
    matar) matar_processo "${2:-}" ;;
    *) mostrar_uso; exit 1 ;;
esac

