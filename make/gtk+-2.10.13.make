MOD=gtk+
VER=2.10.13
THIS=$MOD-$VER
HEX=`echo $THIS | md5sum | cut -d' ' -f1`
TARGET=c:/devel/target/$HEX
DEPS="`/devel/src/tml/latest.sh glib atk cairo pango`"
sed -e 's/need_relink=yes/need_relink=no # no way --tml/' <ltmain.sh >ltmain.temp && mv ltmain.temp ltmain.sh
usedev
usemsvs6
MY_PKG_CONFIG_PATH=""
for D in $DEPS; do
    PATH=/devel/dist/$D/bin:$PATH
    MY_PKG_CONFIG_PATH=/devel/dist/$D/lib/pkgconfig:$MY_PKG_CONFIG_PATH
done
PKG_CONFIG_PATH=$MY_PKG_CONFIG_PATH:$PKG_CONFIG_PATH CC='gcc -mtune=pentium3 -mthreads' CPPFLAGS='-I/opt/gnu/include -I/opt/gnuwin32/include -I/opt/misc/include' LDFLAGS='-L/opt/gnu/lib -L/opt/gnuwin32/lib -L/opt/misc/lib -Wl,--enable-auto-image-base' LIBS=-lintl CFLAGS=-O2 ./configure --with-gdktarget=win32 --with-wintab=/devel/src/wtkit126 --with-ie55=/devel/src/workshop/ie55_lib --enable-debug=yes --enable-explicit-deps=no --disable-gtk-doc --disable-static --prefix=$TARGET &&
libtoolcacheize &&
unset MY_PKG_CONFIG_PATH &&
PATH=/devel/target/$HEX/bin:.libs:$PATH make install &&
(cd $TARGET/bin; strip --strip-unneeded *.dll *.exe) &&
(cd $TARGET/lib/gtk-2.0/2.10.0/loaders; strip --strip-unneeded *.dll) &&
(cd $TARGET/lib/gtk-2.0/2.10.0/immodules; strip --strip-unneeded *.dll) &&
(cd $TARGET/lib/gtk-2.0/2.10.0/engines; strip --strip-unneeded *.dll) &&
PATH=$TARGET/bin:$PATH gdk-pixbuf-query-loaders >$TARGET/etc/gtk-2.0/gdk-pixbuf.loaders &&
grep -v -E 'Automatically generated|Created by|LoaderDir =' <$TARGET/etc/gtk-2.0/gdk-pixbuf.loaders >$TARGET/etc/gtk-2.0/gdk-pixbuf.loaders.temp &&
mv $TARGET/etc/gtk-2.0/gdk-pixbuf.loaders.temp $TARGET/etc/gtk-2.0/gdk-pixbuf.loaders &&
grep -v -E 'Automatically generated|Created by|ModulesPath =' <$TARGET/etc/gtk-2.0/gtk.immodules >$TARGET/etc/gtk-2.0/gtk.immodules.temp &&
mv $TARGET/etc/gtk-2.0/gtk.immodules.temp $TARGET/etc/gtk-2.0/gtk.immodules &&
./gtk-zip.sh &&
(cd /devel/src/tml && zip /tmp/$MOD-dev-$VER.zip make/$THIS.make) &&
manifestify /tmp/$MOD*-$VER.zip
