#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env is required}"
WS_PATH="${WS_PATH:-/ws}"
case "$WS_PATH" in /*) ;; *) WS_PATH="/$WS_PATH" ;; esac
sed -e "s|UUID_PLACEHOLDER|${UUID}|g" \
    -e "s|WSPATH_PLACEHOLDER|${WS_PATH}|g" \
    /etc/xray/config.json.template > /etc/xray/config.json
sed -e "s|PORT_PLACEHOLDER|${PORT}|g" \
    -e "s|WSPATH_PLACEHOLDER|${WS_PATH}|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
/usr/local/bin/xray run -c /etc/xray/config.json &
echo "nginx :${PORT} ws=${WS_PATH}"
exec nginx -g 'daemon off;'
