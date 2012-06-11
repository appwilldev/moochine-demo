PWD=`pwd`
NGINX_FILES=$PWD"/nginx_runtime"

kill -HUP $( cat $NGINX_FILES/logs/nginx.pid )

echo "nginx reloaded!"

