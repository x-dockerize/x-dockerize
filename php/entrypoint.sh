#!/bin/bash
set -e

# Runtime UID/GID adjustment — sunucudaki kullanıcı ile container'daki
# deployer kullanıcısının UID/GID'lerini eşitler.
# Kullanım: docker run -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) ...

if [ -n "$USER_ID" ] && [ "$(id -u deployer)" != "$USER_ID" ]; then
    usermod -u "$USER_ID" deployer
fi

if [ -n "$GROUP_ID" ] && [ "$(id -g deployer)" != "$GROUP_ID" ]; then
    groupmod -g "$GROUP_ID" deployer
fi

exec "$@"
