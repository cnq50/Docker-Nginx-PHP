#!/usr/bin/env bash
docker build  -t registry.cn-qingdao.aliyuncs.com/nobook/php:7.2.13-fpm-nginx .
docker push registry.cn-qingdao.aliyuncs.com/nobook/php:7.2.13-fpm-nginx