#!/bin/sh

set -e

export DOLLAR='$'
export BACKEND_URL=${BACKEND_URL:-"http://localhost:8085"}

case "$APP_TYPE" in
  consent)
    echo "[entrypoint] Running Consent UI setup"
    envsubst < /nginx/nginx.conf.template > /etc/nginx/nginx.conf
    exec nginx -g "daemon off;"
    ;;

  fintech)
    echo "[entrypoint] Running Fintech UI setup"
    erb /etc/nginx/conf.d/default.conf.erb > /etc/nginx/conf.d/default.conf
    # Optionally run the original nginx startup
    exec nginx -g "daemon off;"
    ;;

  *)
    echo "[entrypoint] ERROR: Unknown APP_TYPE: '$APP_TYPE'"
    echo "Set APP_TYPE=consent or APP_TYPE=fintech"
    exit 1
    ;;
esac
