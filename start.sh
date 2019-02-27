#!/usr/bin/env bash
/usr/local/php/sbin/php-fpm -D
exec nginx -g 'daemon off;'