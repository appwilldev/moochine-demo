#!/bin/bash

source `dirname $0`/utils.sh

NGINX_FILES=$APP_ROOT/nginx_runtime

kill -QUIT $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx stopped!"
