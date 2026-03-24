# ----------------------------------
# Environment: Ubuntu 24.04 (Noble) para SA-MP
# ----------------------------------
FROM        ubuntu:24.04

LABEL       author="Alison Barreiro" maintainer="equipemasters@live.com"

ENV         DEBIAN_FRONTEND=noninteractive

# 1. Adiciona arquitetura e instala dependências
# Note que trocamos libncurses5 por libncurses6 + libtinfo6
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
                libncurses6:i386 \
                libtinfo6:i386 \
                libmysqlclient-dev \
                lib32stdc++6 \
                lib32z1 \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# 2. Truque de compatibilidade para SA-MP (Link simbólico para ncurses5)
# O binário do SA-MP procura por libncurses.so.5, nós apontamos para a .6
RUN         ln -s /usr/lib/i386-linux-gnu/libncurses.so.6 /usr/lib/i386-linux-gnu/libncurses.so.5 \
            && ln -s /usr/lib/i386-linux-gnu/libtinfo.so.6 /usr/lib/i386-linux-gnu/libtinfo.so.5

# 3. Configura Timezone (Sem dpkg-reconfigure para evitar erro exit 1)
RUN         ln -snf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
            && echo "America/Sao_Paulo" > /etc/timezone

# 4. Configuração do Usuário
RUN         useradd -d /home/container -m container
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]