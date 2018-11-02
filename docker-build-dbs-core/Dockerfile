from php:fpm-alpine

RUN apk update && apk upgrade

RUN apk --update add \
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

RUN set -ex \
	&& apk --no-cache add postgresql-libs postgresql-dev \
	&& docker-php-ext-install pgsql pdo_pgsql \
	&& apk del postgresql-dev 

RUN docker-php-ext-install mysqli pcntl zip opcache

RUN php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php --install-dir=/usr/bin --filename=composer && \
php -r "unlink('composer-setup.php');" 

RUN php -m
RUN php --ini
RUN composer global require "laravel/installer"
RUN composer create-project --prefer-dist laravel/laravel dbs

#RUN sed -ri -e 's!/usr/local/apache2/htdocs!/usr/local/apache2/dbs!g' /usr/local/apache2/conf/*.conf

WORKDIR /var/www/html/dbs

#RUN ls -l /usr/local/apache2/modules/