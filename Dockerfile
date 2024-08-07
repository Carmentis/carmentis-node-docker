FROM cometbft/cometbft:v0.38.x AS base
LABEL maintainer="info@carmentis.io"
ENV CMTHOME /cometbft
ENV CHAIN_ID=themis

# Arguments for configuration
FROM base AS cometbft2carmentis
WORKDIR /cometbft

USER root

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN mkdir -p /etc/carmentis
COPY ./config/chains/themis.json /etc/carmentis/chains/themis.json

FROM cometbft2carmentis AS carmentis

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["node"]

VOLUME [ "$CMTHOME" ]
