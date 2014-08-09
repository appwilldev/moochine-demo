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

kill -HUP $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx reloaded!"
