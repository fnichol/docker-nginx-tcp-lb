ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ARG NAME
ARG VERSION
ARG REVISION
ARG CREATED

ARG SOURCE=https://github.com/fnichol/docker-nginx-tcp-lb.git

LABEL \
    name="$NAME" \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.authors="Fletcher Nichol <fnichol@nichol.ca>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="$SOURCE" \
    org.opencontainers.image.revision="$REVISION" \
    org.opencontainers.image.created="$CREATED"

COPY --chown=0:0 nginx.conf /etc/nginx/nginx.conf
COPY --chown=0:0 15-generate-templates-from-envvars.sh /docker-entrypoint.d/

RUN rm \
        /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh \
        /etc/nginx/conf.d/default.conf \
    && echo "name=$NAME" > /etc/image-metadata \
    && echo "version=$VERSION" >> /etc/image-metadata \
    && echo "source=$SOURCE" >> /etc/image-metadata \
    && echo "revision=$REVISION" >> /etc/image-metadata \
    && echo "created=$CREATED" >> /etc/image-metadata
