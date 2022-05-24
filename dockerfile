FROM php:7.4-apache

ENV PHP_EXTRA_CONFIGURE_ARGS \
  --enable-intl \
  --enable-opcache \
  --enable-zip \
  --enable-calendar

# Install some must-haves
RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libldap2-dev

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libpng-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg=/usr/include/ --enable-gd

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    curl \
    intl \
    opcache \
    pdo \
    soap \
    xml \
    simplexml \
    iconv \
    zip

COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir /app
RUN chown www-data:www-data /app

# Enable mod_rewrite
RUN a2enmod rewrite

# install mysqli module for php
RUN docker-php-ext-install mysqli \
&& docker-php-ext-enable mysqli

# Install xdebug
RUN pecl install xdebug \
&& docker-php-ext-enable xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1

#install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
&& apt-get install -y nodejs

# install mysql CLI
RUN apt-get update && apt install -y mariadb-client

#install wp cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app