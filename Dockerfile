FROM php:7.2-fpm-alpine
MAINTAINER wish@baffedu.net

RUN set x=1 && \
    apk update && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS zlib-dev imagemagick-dev libtool && \
    apk add --no-cache --virtual .imagick-runtime-deps imagemagick && \
    apk add --no-cache --virtual .gd freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    pecl install imagick && \
    docker-php-ext-install -j$(nproc) gd pcntl pdo_mysql bcmath zip opcache && \
    docker-php-ext-enable imagick && \
    docker-php-source delete && \
    apk del -f .build-deps freetype-dev libpng-dev libjpeg-turbo-dev && \
    rm -rf /tmp/* /var/cache/apk/*

ENV TZ=Asia/Chongqing

RUN apk add -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Chongqing" > /etc/timezone
#    apk del tzdata


ADD ./conf.d/zz.conf /usr/local/etc/php-fpm.d/zz.conf
ADD ./conf.d/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
