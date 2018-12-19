FROM centos:latest

# 设置PHP版本
ENV PHP_VERSION 7.2.13

#安装php
#安装Nginx
RUN  yum update -y \
  && yum install epel-release -y \
  && yum install -y wget git gcc gcc-c++ make automake autoconf perl file tar re2c libjpeg libpng libjpeg-devel libpng-devel libjpeg-turbo freetype freetype-devel \
     libcurl-devel libxml2-devel libjpeg-turbo-devel libXpm-devel libXpm libicu-devel libmcrypt libmcrypt-devel libxslt-devel libxslt openssl openssl-devel bzip2-devel \
  && yum install nginx -y \
  && yum clean all

EXPOSE 80

RUN mkdir ~/download \
  && cd ~/download \
  && wget http://hk2.php.net/distributions/php-$PHP_VERSION.tar.gz \
  && tar -zxf php-$PHP_VERSION.tar.gz \
  && cd php-$PHP_VERSION \
#  && groupadd -r nginx \
#  && useradd -r -g nginx nginx \
  && ./configure \
        --prefix=/usr/local/php \
        --with-config-file-path=/usr/local/php/etc/ \
        --with-config-file-scan-dir=/usr/local/php/conf.d/ \
        --enable-fpm \
        --enable-cgi \
        --with-fpm-user=nginx  \
        --with-fpm-group=nginx \
        --disable-phpdbg \
        --enable-mbstring \
        --enable-calendar \
        --with-xsl \
        --with-openssl \
        --enable-soap \
        --enable-zip \
        --enable-shmop \
        --enable-sockets \
        --with-gd \
        --with-freetype-dir=/usr/include/freetype2/freetype \
        --with-jpeg-dir \
        --with-png-dir \
        --with-xpm-dir \
        --with-xmlrpc \
        --enable-pcntl \
        --enable-intl \
        --with-mcrypt \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-sysvmsg \
        --enable-opcache \
        --with-iconv \
        --with-bz2 \
        --with-curl \
        --enable-mysqlnd \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-zlib \
        --with-gettext \
  && make \
  && make install \
  && cp ~/download/php-$PHP_VERSION/php.ini-production /usr/local/php/etc/php.ini \
  && cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
  && cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf \
  && rm -rf ~/download

EXPOSE 9000

RUN /usr/local/php/bin/pecl install mongodb-1.5.3 \
  && /usr/local/php/bin/pecl install redis-4.2.0 \
  && echo 'extension=redis.so' >> /usr/local/php/etc/php.ini \
  && echo 'extension=mongodb.so' >> /usr/local/php/etc/php.ini

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD ["./start.sh"]



