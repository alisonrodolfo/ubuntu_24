# ----------------------------------
# Environment: Ubuntu 24.04 (Noble)
# ----------------------------------
FROM        ubuntu:24.04

LABEL       author="Alison Barreiro" maintainer="equipemasters@live.com"

# Evita perguntas interativas durante instalação
ENV         DEBIAN_FRONTEND=noninteractive

# Adiciona suporte a pacotes 32 bits e instala dependências
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
                libstdc++6 \
                lib32stdc++6 \
                lib32gcc-s1 \
                lib32z1 \
                lib32ncurses6 \
                default-libmysqlclient-dev \
                iproute2 \
                tzdata \
                libtbb12:i386 \
            && rm -rf /var/lib/apt/lists/*

# Configura timezone de forma moderna
RUN         ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
            && dpkg-reconfigure --frontend noninteractive tzdata

# Cria usuário container
RUN         useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

# Certifique-se que o entrypoint.sh está no mesmo diretório do Dockerfile
COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]