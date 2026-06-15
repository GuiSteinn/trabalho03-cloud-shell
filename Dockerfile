FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apache2 \
        bc \
        curl \
        procps \
        tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

WORKDIR /app

COPY scripts/ /app/scripts/
COPY source/ /app/source/
COPY docker-entrypoint.sh /usr/local/bin/hotel-entrypoint

RUN chmod +x /app/scripts/*.sh /usr/local/bin/hotel-entrypoint \
    && mkdir -p /app/backups /app/logs /app/hotel/dados /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/hotel-entrypoint"]
