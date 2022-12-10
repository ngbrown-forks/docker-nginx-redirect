FROM ghcr.io/nginxinc/nginx-unprivileged:alpine-slim

ENV SERVER_NAME='localhost' \
    SERVER_REDIRECT_PATH='$request_uri' \
    SERVER_REDIRECT_SCHEME='$redirect_scheme' \
    SERVER_ACCESS_LOG='/dev/stdout' \
    SERVER_ERROR_LOG='/dev/stderr' \
    SERVER_HEALTHCHECK_ENABLED=0 \
    SERVER_HEALTHCHECK_RESPONSE_CODE=200 \
    SERVER_HEALTHCHECK_RESPONSE_BODY='alive' \
    SERVER_HEALTHCHECK_PATH='healthcheck'

ARG UID=101

ADD run.sh /run.sh
ADD default.conf /etc/nginx/conf.d/default.conf
ADD healthcheck.conf /etc/nginx/includes/healthcheck.conf

USER root
RUN chmod +x /run.sh \
    && chown -R $UID:0 /etc/nginx \
    && chmod -R g+w /etc/nginx
USER $UID

EXPOSE 8080

CMD ["/run.sh"]
