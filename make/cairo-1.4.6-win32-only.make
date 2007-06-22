MOD=cairo
VER=1.4.6-win32-only
BASEVER=${VER%-win32-only}
THIS=$MOD-$VER
HEX=`echo $THIS | md5sum | cut -d' ' -f1`
DEPS=
sed -e 's/need_relink=yes/need_relink=no # no way --tml/' <ltmain.sh >ltmain.temp && mv ltmain.temp ltmain.sh
usedev
usemsvs6
unset MY_PKG_CONFIG_PATH
for D in $DEPS; do
    PATH=/devel/dist/$D/bin:$PATH
    MY_PKG_CONFIG_PATH=/devel/dist/$D/lib/pkgconfig:$MY_PKG_CONFIG_PATH
done
PKG_CONFIG_PATH=$MY_PKG_CONFIG_PATH:$PKG_CONFIG_PATH CC='gcc -mtune=pentium3' CFLAGS=-O2 ./configure --disable-static --enable-png=no --enable-ps=no --enable-pdf=no --enable-svg=no --enable-freetype=no --prefix=c:/devel/target/$HEX &&
libtoolcacheize &&
PATH=/devel/target/$HEX/bin:$PATH make zips &&
mv /tmp/$MOD-$BASEVER.zip /tmp/$MOD-$VER.zip &&
mv /tmp/$MOD-dev-$BASEVER.zip /tmp/$MOD-dev-$VER.zip &&
cp -p src/cairo.def /devel/target/$HEX/lib &&
mkdir -p /devel/target/$HEX/share/doc/$MOD-$VER &&
cp -p COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1 /devel/target/$HEX/share/doc/$MOD-$VER &&
(cd /devel/target/$HEX/lib &&
lib.exe -def:cairo.def -out:cairo.lib &&
cd .. &&
zip /tmp/$MOD-dev-$VER.zip lib/cairo.def lib/cairo.lib &&
zip -r /tmp/$MOD-$VER.zip share/doc/$MOD-$VER &&
cd /devel/src/tml && 
zip /tmp/$MOD-dev-$VER.zip make/$THIS.make) &&
manifestify /tmp/$MOD-$VER.zip /tmp/$MOD-dev-$VER.zip
