# =============================================================================
# x-dockerize — PHP-CLI base image
#
# Build:
#   docker build --build-arg PHP_VERSION=8.5 -t ghcr.io/x-dockerize/php:8.5-cli .
# =============================================================================
ARG PHP_VERSION=8.5

FROM php:${PHP_VERSION}-cli

ARG PHP_VERSION

LABEL org.opencontainers.image.source="https://github.com/x-dockerize/x-dockerize"
LABEL org.opencontainers.image.description="PHP ${PHP_VERSION} CLI base image with common extensions"
LABEL org.opencontainers.image.licenses="MIT"

ENV TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
        # gmp
        libgmp-dev \
        # intl
        libicu-dev \
        # gd
        libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev \
        # memcached
        libmemcached-dev libsasl2-dev \
        # pdo_pgsql
        libpq-dev \
        # mongodb, swoole (TLS)
        libssl-dev \
        # soap
        libxml2-dev \
        # zip
        libzip-dev zlib1g-dev \
        # 7zip binary
        p7zip-full \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        # Arbitrary precision mathematics
        bcmath \
        # Image metadata extraction
        exif \
        # Image processing (JPEG, PNG, WebP, FreeType)
        gd \
        # Large integer arithmetic (cryptography, blockchain)
        gmp \
        # Internationalization (date, number, collation formatting)
        intl \
        # Process control (signals, forks — required by Horizon)
        pcntl \
        # MySQL database driver
        pdo_mysql \
        # PostgreSQL database driver
        pdo_pgsql \
        # SOAP web services
        soap \
        # ZIP archive handling
        zip \
    && pecl install igbinary msgpack mongodb swoole \
    && docker-php-ext-enable igbinary msgpack mongodb swoole \
    && pecl install --configureoptions 'enable-redis-igbinary="yes" enable-redis-lzf="no" enable-redis-zstd="no"' redis \
    && docker-php-ext-enable redis \
    && pecl install --configureoptions 'enable-memcached-igbinary="yes"' memcached \
    && docker-php-ext-enable memcached \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.pearrc

RUN groupadd -g 1000 deployer \
    && useradd -u 1000 -g deployer -m deployer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php", "-a"]
