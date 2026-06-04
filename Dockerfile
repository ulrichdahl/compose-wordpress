FROM wordpress:php8.5-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    gd \
    zip \
    xml \
    intl \
    opcache

# HIGH TRAFFIC TUNING
RUN echo "[www]\n\
pm = dynamic\n\
pm.max_children = 50\n\
pm.start_servers = 10\n\
pm.min_spare_servers = 5\n\
pm.max_spare_servers = 20\n\
pm.max_requests = 500" > /usr/local/etc/php-fpm.d/zz-tuning.conf

RUN chown -R www-data:www-data /var/www/html
