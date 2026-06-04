FROM wordpress:php8.5-fpm

RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev zip unzip \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libfreetype6-dev \
    libxml2-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl

RUN docker-php-ext-install -j$(nproc) \
    gd \
    zip \
    intl

# HIGH TRAFFIC TUNING: PHP-FPM proces-optimering
RUN echo "[www]\n\
pm = dynamic\n\
pm.max_children = 50\n\
pm.start_servers = 10\n\
pm.min_spare_servers = 5\n\
pm.max_spare_servers = 20\n\
pm.max_requests = 500" > /usr/local/etc/php-fpm.d/zz-tuning.conf

# Sørg for korrekte rettigheder på WordPress-mappen
RUN chown -R www-data:www-data /var/www/html
