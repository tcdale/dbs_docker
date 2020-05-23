from php:rc-fpm-alpine

RUN \
 apk update && apk upgrade && \
 apk --update add \
   libzip \
   libzip-dev

RUN \
  apk update && \
  apk upgrade && \
  apk --update add \
    wget \
    curl \
    grep \
    build-base \
    libmemcached-dev \
    libmcrypt-dev \
    libxml2-dev \
    zlib-dev \
    autoconf \
    cyrus-sasl-dev \
    libgsasl-dev \
    supervisor \
    libsodium

RUN \
  set -ex && \
	apk --no-cache add postgresql-libs postgresql-dev && \
	docker-php-ext-install pgsql pdo_pgsql mysqli pcntl zip opcache && \
	apk del postgresql-dev 

RUN \
  php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir=/usr/bin --filename=composer && \
  php -r "unlink('composer-setup.php');" 

RUN \
  composer global require "laravel/installer" && \
  composer create-project --prefer-dist laravel/laravel dbs 

RUN \
  composer require laravel/ui 

RUN \
  composer update --no-scripts

WORKDIR /var/www/html/dbs

RUN \
  chgrp -R www-data storage bootstrap/cache && \
  chmod -R ug+rwx storage bootstrap/cache

RUN \
  /usr/local/bin/php -m && \
  /usr/local/bin/php -version
