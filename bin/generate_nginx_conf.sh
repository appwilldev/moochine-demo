#!/bin/bash

# set global variables
#export OPENRESTY_HOME=/usr/local/openresty
#export MOOCHINE_HOME=/your/path/to/moochine

source `dirname $0`/utils.sh

NGINX_FILES=$APP_ROOT/nginx_runtime
CURRENT_USER=$(id -u -n)

if [[ $NGINX_DAEMON_FLAG = "" ]]; then
    NGINX_DAEMON_FLAG=on
else
    NGINX_DAEMON_FLAG=off
fi

mkdir -p $NGINX_FILES/conf
mkdir -p $NGINX_FILES/logs

cp $APP_ROOT/conf/mime.types $NGINX_FILES/conf/

sed -e "s|__MOOCHINE_HOME_VALUE__|$MOOCHINE_HOME|" \
    -e "s|__MOOCHINE_APP_PATH_VALUE__|$APP_ROOT|" \
    -e "s|__NGINX_USER__|$CURRENT_USER|" \
    -e "s|__NGINX_GRP__|$CURRENT_USER|" \
    -e "s|__NGINX_DAEMON_FLAG__|$NGINX_DAEMON_FLAG|" \
    $APP_ROOT/conf/nginx.conf > $NGINX_FILES/conf/p-nginx.conf
