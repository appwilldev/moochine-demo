#!/bin/bash

# set global variables
#export OPENRESTY_HOME=/usr/local/openresty
#export MOOCHINE_HOME=/your/path/to/moochine

PWD=`pwd`

NGINX_FILES=$PWD"/nginx_runtime"
APP_NAME="moochine-demo"

mkdir -p $NGINX_FILES
mkdir -p $NGINX_FILES"/conf"
mkdir -p $NGINX_FILES"/logs"

cp $PWD"/conf/mime.types" $NGINX_FILES"/conf/"

cat $PWD/conf/nginx.conf | sed -e "s|__MOOCHINE_HOME_VALUE__|$MOOCHINE_HOME|"\
                         | sed -e "s|__MOOCHINE_APP_PATH_VALUE__|$PWD|"\
                         | sed -e "s|__MOOCHINE_APP_NAME_VALUE__|$APP_NAME|"\
                         > $NGINX_FILES/conf/p-nginx.conf 

