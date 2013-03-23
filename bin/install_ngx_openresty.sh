#!/bin/bash

mkdir -p ~/openresty_downloads
cd ~/openresty_downloads

apt-get install build-essential libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl libyaml-dev libmagickcore-dev libmagickwand-dev git

wget http://agentzh.org/misc/nginx/drizzle7-2011.07.21.tar.gz
tar xzvf drizzle7-2011.07.21.tar.gz
cd drizzle7-2011.07.21/
./configure --without-server
make libdrizzle-1.0
make install-libdrizzle-1.0

cd ..

wget http://ftp.postgresql.org/pub/source/v9.2.3/postgresql-9.2.3.tar.gz
tar vfxz postgresql-9.2.3.tar.gz
cd postgresql-9.2.3
./configure
make
make install

cd ..

wget http://agentzh.org/misc/nginx/ngx_openresty-1.2.7.1.tar.gz
tar xzvf ngx_openresty-1.2.7.1.tar.gz
cd ngx_openresty-1.2.7.1
./configure --with-http_stub_status_module --with-http_realip_module --with-pcre-jit --with-luajit --with-http_postgres_module --with-http_drizzle_module --with-libpq=/usr/local/pgsql -j6
make -j6
make install

cd ..

git clone git://github.com/ldmiao/yaml.git
cd yaml
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install

cd ..

git clone git://github.com/azurewang/lua-resty-postgres.git
cd lua-resty-postgres
cp lib/resty/postgres.lua /usr/local/openresty/lualib/resty/

cd ..

git clone git://github.com/ldmiao/lua-cmsgpack.git
cd lua-cmsgpack
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install

cd ..

git clone git://github.com/ldmiao/lua-zlib.git
cd lua-zlib
make linux
make install

cd ..

git clone git://github.com/ldmiao/luafilesystem.git
cd luafilesystem
make
make install

cd ..

git clone git://github.com/leafo/magick.git
cd magick
cp magick.lua /usr/local/openresty/lualib/
cp -r magick /usr/local/openresty/lualib/

cd ..

wget http://www.xunsearch.com/scws/down/scws-1.2.1.tar.bz2
tar vfxj scws-1.2.1.tar.bz2
cd scws-1.2.1
./configure && make && make install
chmod a+r /usr/local/scws/dict.utf8.xdb
cd ..
git clone git://github.com/appwilldev/luascws.git
cd luascws
cp scws_header.lua /usr/local/openresty/lualib/
cp scws.lua /usr/local/openresty/lualib/

cd ..

