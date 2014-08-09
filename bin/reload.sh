#!/bin/bash

source `dirname $0`/utils.sh

$APP_ROOT/bin/generate_nginx_conf.sh

NGINX_FILES=$APP_ROOT/nginx_runtime

kill -HUP $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx reloaded!"
