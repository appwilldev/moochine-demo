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
rm -rf yaml
git clone git://github.com/ldmiao/yaml.git
cd yaml
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-resty-awtp02..."
echo "------------------------------------------------------------------------"

rm -rf lua-resty-awtp02
git clone git://github.com/appwilldev/lua-resty-awtp02.git
cd lua-resty-awtp02
cp lib/resty/awtp02.lua /usr/local/openresty/lualib/resty/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL pgmoon ..."
echo "------------------------------------------------------------------------"

rm -rf pgmoon
git clone git://github.com/leafo/pgmoon.git
mkdir -p /usr/local/openresty/lualib/pgmoon
cd pgmoon
cp pgmoon.lua /usr/local/openresty/lualib/
cp pgmoon/*.lua /usr/local/openresty/lualib/pgmoon/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-resty-http..."
echo "------------------------------------------------------------------------"

rm -rf lua-resty-http
git clone git://github.com/pintsized/lua-resty-http.git
cd lua-resty-http
cp lib/resty/http.lua /usr/local/openresty/lualib/resty/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-cmsgpack..."
echo "------------------------------------------------------------------------"

rm -rf lua-cmsgpack
git clone git://github.com/ldmiao/lua-cmsgpack.git
cd lua-cmsgpack
make -f Makefile.linux_openresty
make -f Makefile.linux_openresty install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-zlib..."
echo "------------------------------------------------------------------------"

rm -rf lua-zlib
git clone git://github.com/ldmiao/lua-zlib.git
cd lua-zlib
make linux
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL luafilesystem..."
echo "------------------------------------------------------------------------"

rm -rf luafilesystem
git clone git://github.com/ldmiao/luafilesystem.git
cd luafilesystem
make
make install
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL magick..."
echo "------------------------------------------------------------------------"

rm -rf magick
apt-get install imagemagick libmagickcore-dev libmagickwand-dev
git clone git://github.com/leafo/magick.git
cd magick
cp magick.lua /usr/local/openresty/lualib/
cp -r magick /usr/local/openresty/lualib/
cd ..

echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL luascws..."
echo "------------------------------------------------------------------------"

rm -rf scws-1.2.1.tar.bz2 scws-1.2.1 luascws
wget http://www.xunsearch.com/scws/down/scws-1.2.1.tar.bz2
tar vfxj scws-1.2.1.tar.bz2
cd scws-1.2.1
./configure && make && make install
cd ..
git clone git://github.com/appwilldev/luascws.git
cd luascws
cp scws_header.lua /usr/local/openresty/lualib/
cp scws.lua /usr/local/openresty/lualib/
cd ..

rm -rf scws-dict-chs-utf8.tar.bz2 dict.utf8.xdb
wget http://www.xunsearch.com/scws/down/scws-dict-chs-utf8.tar.bz2
tar vfxj scws-dict-chs-utf8.tar.bz2
mkdir -p /usr/local/scws
cp dict.utf8.xdb /usr/local/scws/
chmod a+r /usr/local/scws/dict.utf8.xdb


echo ""
echo "------------------------------------------------------------------------"
echo "INSTALL lua-resty-hoedown..."
echo "------------------------------------------------------------------------"

rm -rf hoedown
git clone https://github.com/hoedown/hoedown.git
cd hoedown
make
cp libhoedown.so /usr/local/openresty/lualib/
cd ..

rm -rf lua-resty-hoedown
git clone https://github.com/bungle/lua-resty-hoedown.git
cd lua-resty-hoedown
cp -r lib/resty/* /usr/local/openresty/lualib/resty/
cd ..

ldconfig

echo ""
echo "------------------------------------------------------------------------"
echo "DONE!"
echo "------------------------------------------------------------------------"

