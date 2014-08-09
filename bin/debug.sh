#!/bin/bash

source `dirname $0`/utils.sh
NGINX_FILES=$APP_ROOT/nginx_runtime

$APP_ROOT/bin/stop.sh

echo "" > $NGINX_FILES/logs/error.log

$APP_ROOT/bin/start.sh

echo "tail -f $NGINX_FILES/logs/error.log"
tail -f $NGINX_FILES/logs/error.log
