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

rm -rf postgresql-9.5.4.tar.gz postgresql-9.5.4
wget http://ftp.postgresql.org/pub/source/v9.5.4/postgresql-9.5.4.tar.gz
tar vfxz postgresql-9.5.4.tar.gz
cd postgresql-9.5.4
./configure
make -j6
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL Redis..."
echo "------------------------------------------------------------------------"

rm -rf redis-3.2.3.tar.gz redis-3.2.3
wget http://download.redis.io/releases/redis-3.2.3.tar.gz
tar xzvf redis-3.2.3.tar.gz
cd redis-3.2.3
./configure
make
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL OpenResty..."
echo "------------------------------------------------------------------------"

rm -rf openresty-1.9.15.1.tar.gz openresty-1.9.15.1
wget https://openresty.org/download/openresty-1.9.15.1.tar.gz
tar xzvf openresty-1.9.15.1.tar.gz
cd openresty-1.9.15.1
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
