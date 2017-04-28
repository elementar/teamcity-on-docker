FROM jetbrains/teamcity-base

MAINTAINER Elementar Sistemas <contato@elementarsistemas.com.br>

# TeamCity data is stored in a volume to facilitate container upgrade
VOLUME ["/data"]
ENV TEAMCITY_DATA_PATH /data/teamcity

# Download and install TeamCity to /opt
RUN curl --fail -sL "https://download.jetbrains.com/teamcity/TeamCity-2017.1.1.tar.gz" | tar zx -C /opt

EXPOSE 8111
CMD ["/opt/TeamCity/bin/teamcity-server.sh", "run"]
