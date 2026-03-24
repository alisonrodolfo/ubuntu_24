# ----------------------------------
# Environment: Ubuntu 24.04 (Noble) para SA-MP
# ----------------------------------
FROM        ubuntu:24.04

LABEL       author="Alison Barreiro" maintainer="equipemasters@live.com"

ENV         DEBIAN_FRONTEND=noninteractive

# 1. Adiciona arquitetura i386
# 2. Instala dependências essenciais de 64 bits
# 3. Instala as bibliotecas de compatibilidade 32 bits necessárias para o SA-MP
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get -y upgrade \
            && apt-get install -y --no-install-recommends \
                curl \
                unzip \
                wget \
                git \
                jq \
                tar \
                ca-certificates \
                iproute2 \
                tzdata \
                libstdc++6 \
                libstdc++6:i386 \
                libncurses5:i386 \
                libssl-dev:i386 \
                libmysqlclient-dev \
            && apt-get install -y --no-install-recommends \
                lib32stdc++6 \
                lib32z1 \
                libtbb-dev:i386 || true \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Configura timezone
RUN         ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
            && dpkg-reconfigure --frontend noninteractive tzdata

# Cria usuário container (Padrão Pterodactyl)
RUN         useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

# Garante que o entrypoint tenha permissão (caso o Windows tenha removido)
# Como você usa Windows, isso previne erros de "Permission Denied" no GitHub Actions
USER root
RUN chmod +x /entrypoint.sh
USER container

CMD         ["/bin/bash", "/entrypoint.sh"]