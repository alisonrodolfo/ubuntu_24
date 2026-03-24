#!/bin/bash
cd /home/container || exit 1

# Deixa o IP interno disponível (usado por alguns jogos)
export INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')

# Exporta proxy passado pelo Egg (ou fallback vazio)
export HTTP_PROXY="${HTTP_PROXY:-}"
export HTTPS_PROXY="${HTTPS_PROXY:-}"
export NO_PROXY="${NO_PROXY:-}"

export http_proxy="${HTTP_PROXY:-}"
export https_proxy="${HTTPS_PROXY:-}"
export no_proxy="${NO_PROXY:-}"

# Monta o comando de inicialização substituindo variáveis do Pterodactyl
MODIFIED_STARTUP=$(eval echo $(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g'))

echo ":/home/container$ ${MODIFIED_STARTUP}"

# Executa o servidor
exec ${MODIFIED_STARTUP}
