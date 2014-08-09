#!/bin/bash

source `dirname $0`/utils.sh

case $1 in
    -f)
        export NGINX_DAEMON_FLAG=on
        ;;
    *)
        :
        ;;
esac

$APP_ROOT/bin/generate_nginx_conf.sh

NGINX_FILES=$APP_ROOT/nginx_runtime

$OPENRESTY_HOME/nginx/sbin/nginx -p $NGINX_FILES/ -c conf/p-nginx.conf

echo "nginx started!"
