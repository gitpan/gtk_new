MOD=pango
VER=1.16.4
THIS=$MOD-$VER
HEX=`echo $THIS | md5sum | cut -d' ' -f1`
DEPS=`/devel/src/tml/latest.sh glib cairo`
sed -e 's/need_relink=yes/need_relink=no # no way --tml/' <ltmain.sh >ltmain.temp && mv ltmain.temp ltmain.sh
usedev
usemsvs6
MY_PKG_CONFIG_PATH=""
for D in $DEPS; do
    PATH=/devel/dist/$D/bin:$PATH
    MY_PKG_CONFIG_PATH=/devel/dist/$D/lib/pkgconfig:$MY_PKG_CONFIG_PATH
done
PKG_CONFIG_PATH=$MY_PKG_CONFIG_PATH:$PKG_CONFIG_PATH CC='gcc -mtune=pentium3 -mthreads' CPPFLAGS='-I/opt/gnu/include' LDFLAGS='-L/opt/gnu/lib -Wl,--enable-auto-image-base' CFLAGS=-O2 ./configure --enable-debug=yes --disable-gtk-doc --without-x --prefix=c:/devel/target/$HEX  --enable-explicit-deps=no --with-included-modules=yes &&
libtoolcacheize &&
unset MY_PKG_CONFIG_PATH &&
PATH=/devel/target/$HEX/bin:.libs:$PATH make install &&
(cd /devel/target/$HEX/bin; strip --strip-unneeded *.dll) &&
cp /devel/dist/pango-1.14.9/etc/pango/pango.aliases /devel/target/$HEX/etc/pango &&
./pango-zip.sh &&
(cd /devel/src/tml && zip /tmp/$MOD-dev-$VER.zip make/$THIS.make) &&
manifestify /tmp/$MOD*-$VER.zip
