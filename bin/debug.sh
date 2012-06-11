PWD=`pwd`
NGINX_FILES=$PWD"/nginx_runtime"
echo "" > $NGINX_FILES/logs/error.log 
./bin/stop.sh ; 
./bin/start.sh ;  
tail -f $NGINX_FILES/logs/error.log

