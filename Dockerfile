FROM alpine:3.12

ENV PEAR_PACKAGES foo

WORKDIR /tmp

RUN apk --no-cache add \
        bash \
        ca-certificates \
        curl \
        git \
        php7 \
        php7-bcmath \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-exif \
        php7-fileinfo \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-opcache \
        php7-openssl \
        php7-pcntl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-phar \
        php7-session \
        php7-simplexml \
        php7-soap \
        php7-tokenizer \
        php7-xdebug \
        php7-xml \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zip \
        php7-zlib \
        php7-sockets \
        unzip \
    && php -r "copy('https://pear.php.net/go-pear.phar', 'go-pear.phar');" \
    && php go-pear.phar \
    && php -r "unlink('go-pear.phar');" \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && composer require "phpunit/phpunit:^7" --prefer-source --no-interaction \
    && composer require "phpunit/php-invoker" --prefer-source --no-interaction \
    && composer require spatie/phpunit-watcher --dev \
    && composer require monolog/monolog \
    && ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit \
    && ln -s /tmp/vendor/bin/phpunit-watcher /usr/local/bin/phpunit-watcher \
    && sed -i 's/nn and/nn, Nicolas Frey (Docker) and/g' /tmp/vendor/phpunit/phpunit/src/Runner/Version.php \
    && sed -i 's@new Process(\[".*"\])@new Process(["php", "/usr/local/bin/phpunit"])@g' /tmp/vendor/spatie/phpunit-watcher/src/Screens/Phpunit.php \
    # Enable X-Debug
    && sed -i 's/\;z/z/g' /etc/php7/conf.d/xdebug.ini \
    && php -m | grep -i xdebug

ONBUILD RUN \
    { \
        [ "${PEAR_PACKAGES}" != "foo" ]; \
    } || exit 0 && pear install ${PEAR_PACKAGES}


VOLUME ["/app"]

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/phpunit"]

CMD ["--help"]