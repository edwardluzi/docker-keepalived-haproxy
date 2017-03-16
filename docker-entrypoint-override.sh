#!/bin/sh
set -e

# exec haproxy entry poing script
exec /docker-entrypoint.sh "$@" &

# exec keepalived entry point sdcript
exec /keepalived/start-keepalived.sh

