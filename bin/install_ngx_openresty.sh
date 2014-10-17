#!/bin/bash

mkdir -p ~/openresty_downloads
cd ~/openresty_downloads

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL Required Library..."
echo "------------------------------------------------------------------------"

apt-get install build-essential daemontools bzip2 zip libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl libyaml-dev libmagickcore-dev libmagickwand-dev libcloog-ppl0 libgeoip-dev git htop iotop tmux rcconf rlwrap strace vim curl python-dev python-setuptools realpath flex bison

easy_install pyyaml

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL libdrizzle..."
echo "------------------------------------------------------------------------"

rm -rf drizzle7-2011.07.21.tar.gz drizzle7-2011.07.21
wget http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gz
tar xzvf drizzle7-2011.07.21.tar.gz
cd drizzle7-2011.07.21/
./configure --without-server
make libdrizzle-1.0
make install-libdrizzle-1.0
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL PostgreSQL..."
echo "------------------------------------------------------------------------"

rm -rf postgresql-9.3.5.tar.gz postgresql-9.3.5
wget http://ftp.postgresql.org/pub/source/v9.3.5/postgresql-9.3.5.tar.gz
tar vfxz postgresql-9.3.5.tar.gz
cd postgresql-9.3.5
./configure
make -j6
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL Redis..."
echo "------------------------------------------------------------------------"

rm -rf redis-2.8.17.tar.gz redis-2.8.17
wget http://download.redis.io/releases/redis-2.8.17.tar.gz
tar xzvf redis-2.8.17.tar.gz
cd redis-2.8.17
./configure
make
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL OpenResty..."
echo "------------------------------------------------------------------------"

rm -rf ngx_openresty-1.7.4.1.tar.gz ngx_openresty-1.7.4.1
wget http://agentzh.org/misc/nginx/ngx_openresty-1.7.4.1.tar.gz
tar xzvf ngx_openresty-1.7.4.1.tar.gz
cd ngx_openresty-1.7.4.1
./configure --with-http_stub_status_module --with-http_realip_module --with-pcre-jit --with-luajit --with-http_postgres_module --with-http_drizzle_module --with-libpq=/usr/local/pgsql --with-http_geoip_module -j6
make -j6
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "Download MaxMind GeoIP data..."
echo "------------------------------------------------------------------------"

rm -rf GeoIP.dat.gz GeoIP.dat
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gzip -d GeoIP.dat.gz
mkdir -p /usr/local/geoip
cp GeoIP.dat /usr/local/geoip/
cd ..

ldconfig

echo ""
echo "------------------------------------------------------------------------"
echo "DONE!"
echo "------------------------------------------------------------------------"
