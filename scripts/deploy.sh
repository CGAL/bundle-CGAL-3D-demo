#!/bin/sh

set -e
PATH=/usr/lib64/qt5/bin:$PATH
export PATH
#for ldd to find boost libs
LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
echo "DEPLOYING....."
[ -d /dist ] || mkdir /dist
[ -d /dist/usr ] || mkdir /dist/usr
[ -d /dist/usr/bin ] || mkdir /dist/usr/bin
[ -d /dist/usr/lib ] || mkdir -p /dist/usr/lib
[ -d /results ] || mkdir /results
cd /build/demo/Polyhedron
find -name '*.so' -a -not -name '*plugin*.so' | xargs -l10 cp --preserve=mode --parents -t /dist/usr/lib
cp --preserve=mode Polyhedron_3 /dist/usr/bin/
cp -r --preserve=mode --parents implicit_functions/*.so /dist/usr/bin/
cp -r --preserve=mode --parents Plugins/*/*.so /dist/usr/bin/
#for some reason those ones are missing
cp -r --preserve=mode --parents /usr/lib64/libpcre* /dist
mv -f /dist/usr/lib64/* /dist/usr/lib
linuxdeployqt /dist/usr/bin/Polyhedron_3  $(find -name '*plugin*.so' -printf ' -executable=/dist/usr/bin/%p')  -bundle-non-qt-libs -verbose=2
$SHELL -$- /scripts/create_appimage.sh
echo "DEPLOYED"
