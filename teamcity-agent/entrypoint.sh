#!/usr/bin/env bash

set -e

# adiciona o ID do grupo do docker ao usuário teamcity
DOCKER_GID=$( stat -c %g /var/run/docker.sock )
groupadd -g ${DOCKER_GID} docker-${DOCKER_GID} || true
usermod -aG ${DOCKER_GID} teamcity

exec sudo -EHiu teamcity TEAMCITY_SERVER="$TEAMCITY_SERVER" "$@"