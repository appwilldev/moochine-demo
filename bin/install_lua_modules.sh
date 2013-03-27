#!/bin/bash

mkdir -p ~/openresty_downloads
cd ~/openresty_downloads

echo "------------------------------------------------------------------------"
echo "INSTALL Lua Modules..."
echo "------------------------------------------------------------------------"

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL yaml..."
echo "------------------------------------------------------------------------"

apt-get install libyaml-dev
git clone git://github.com/ldmiao/yaml.git
cd yaml
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-resty-awtp02..."
echo "------------------------------------------------------------------------"

git clone git://github.com/appwilldev/lua-resty-awtp02.git
cd lua-resty-awtp02
cp lib/resty/awtp02.lua /usr/local/openresty/lualib/resty/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-resty-postgres..."
echo "------------------------------------------------------------------------"

git clone git://github.com/azurewang/lua-resty-postgres.git
cd lua-resty-postgres
cp lib/resty/postgres.lua /usr/local/openresty/lualib/resty/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-cmsgpack..."
echo "------------------------------------------------------------------------"

git clone git://github.com/ldmiao/lua-cmsgpack.git
cd lua-cmsgpack
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-zlib..."
echo "------------------------------------------------------------------------"

git clone git://github.com/ldmiao/lua-zlib.git
cd lua-zlib
make linux
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL luafilesystem..."
echo "------------------------------------------------------------------------"

git clone git://github.com/ldmiao/luafilesystem.git
cd luafilesystem
make
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL magick..."
echo "------------------------------------------------------------------------"

apt-get install libmagickcore-dev libmagickwand-dev
git clone git://github.com/leafo/magick.git
cd magick
cp magick.lua /usr/local/openresty/lualib/
cp -r magick /usr/local/openresty/lualib/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL luascws..."
echo "------------------------------------------------------------------------"

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

echo ""
echo "------------------------------------------------------------------------"
echo "DONE!"
echo "------------------------------------------------------------------------"

