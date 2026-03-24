# ----------------------------------
# Environment: Ubuntu 24.04 (Noble) para SA-MP
# ----------------------------------
FROM        ubuntu:24.04

LABEL       author="Alison Barreiro" maintainer="equipemasters@live.com"

ENV         DEBIAN_FRONTEND=noninteractive

# 1. Instalação de dependências e libs 32-bit para SA-MP
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
                libmysqlclient-dev \
                lib32stdc++6 \
                lib32z1 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# 2. Configura Timezone (Nova forma para evitar erro de dpkg-reconfigure)
RUN         ln -snf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
            && echo "America/Sao_Paulo" > /etc/timezone

# 3. Configuração do Usuário
RUN         useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

# Copia o entrypoint
COPY        ./entrypoint.sh /entrypoint.sh

# O CMD deve rodar o bash para executar o seu script
CMD         ["/bin/bash", "/entrypoint.sh"]