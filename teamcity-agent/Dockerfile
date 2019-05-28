FROM jetbrains/teamcity-agent

MAINTAINER Elementar Sistemas <contato@elementarsistemas.com.br>

# instala os pacotes necessários do SO
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y curl unzip sudo make ruby \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# instala a gema rake
RUN gem install --no-doc rake

# define as variáveis básicas de ambiente
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# habilita uso de "sudo" pelo usuário do buildagent
RUN echo "%buildagent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/buildagent
