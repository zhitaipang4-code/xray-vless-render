FROM alpine:3.20
ARG XRAY_VERSION=26.10.21
RUN apk add --no-cache ca-certificates curl unzip tzdata nginx gettext \
 && curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" \
 && mkdir -p /tmp/xray \
 && unzip /tmp/xray.zip -d /tmp/xray \
 && install -m 755 /tmp/xray/xray /usr/local/bin/xray \
 && rm -rf /tmp/xray /tmp/xray.zip \
 && mkdir -p /etc/xray /run/nginx /var/www/html \
 && echo 'ok' > /var/www/html/index.html
COPY config.json.template /etc/xray/config.json.template
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV PORT=8080
EXPOSE 8080
CMD ["/entrypoint.sh"]
