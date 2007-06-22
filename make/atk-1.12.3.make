MOD=atk
VER=1.12.3
THIS=$MOD-$VER
DEPS=`/devel/src/tml/latest.sh glib`
sed -e 's/need_relink=yes/need_relink=no # no way --tml/' <ltmain.sh >ltmain.temp && mv ltmain.temp ltmain.sh
usestable
usemsvs6
unset MY_PKG_CONFIG_PATH
for D in $DEPS; do
    PATH=/devel/dist/$D/bin:$PATH
    MY_PKG_CONFIG_PATH=/devel/dist/$D/lib/pkgconfig:$MY_PKG_CONFIG_PATH
done
PKG_CONFIG_PATH=$MY_PKG_CONFIG_PATH:$PKG_CONFIG_PATH CC='gcc -mtune=pentium3' CPPFLAGS='-I/opt/gnu/include' LDFLAGS='-L/opt/gnu/lib -Wl,--enable-auto-image-base' CFLAGS=-O2 ./configure --disable-gtk-doc --disable-static --prefix=c:/devel/target/$THIS
libtoolcacheize
(cd atk; make atkmarshal.h atkmarshal.c) &&
PATH=/devel/target/$THIS/bin:.libs:$PATH make install &&
(cd /devel/target/$THIS/bin; strip --strip-unneeded *.dll) &&
./atk-zip.sh &&
(cd /devel/src/tml && zip /tmp/$MOD-dev-$VER.zip make/$THIS.make)
