FROM php:5.6-apache
MAINTAINER Scott van Brug scottvanbrug@gmail.com

RUN apt-get update -q && apt-get install -yq \
  git \
  libssl-dev \
  libmcrypt-dev \
  && until rm -rf /var/lib/apt/lists; do sleep 1; done

RUN cd ~ \
  && pecl download mongo-1.6.12 \
  && tar -zxf mongo-1.6.12.tgz \
  && rm mongo-1.6.12.tgz \
  && cd mongo-1.6.12 \
  && phpize \
  && ./configure --with-php-config=/usr/local/bin/php-config --with-mongo-sasl=no \
  && make all \
  && make install \
  && docker-php-ext-enable mongo.so

RUN docker-php-ext-install mcrypt

RUN cd /var/www/html \
  && git clone https://github.com/perftools/xhgui.git \
  && cd xhgui \
  && chmod -R 0777 cache \
  && php install.php

RUN chown -R www-data:www-data /var/www/html/xhgui/webroot/

COPY conf/config.php /var/www/html/xhgui/config/config.php

COPY conf/xhgui.conf /etc/apache2/sites-available/xhgui.conf

RUN a2ensite xhgui.conf && a2enmod rewrite

EXPOSE 80
