#!/bin/sh

set -e
PATH=/usr/lib64/qt5/bin:$PATH
export PATH

[ -d /dist ] || mkdir /dist
cd /build/demo/Polyhedron
find -name '*.so' | xargs -l10 cp --parents -t /dist
cp Polyhedron_3 /dist/
[ -d /dist/lib ] || mkdir -p /dist/lib
cp -a /lib64/libudev.so* /dist/lib/
[ -d /dist/plugins/platforms ] || mkdir -p /dist/plugins/platforms
cp -a /usr/lib64/qt5/plugins/platforms/libqminimal.so /dist/plugins/platforms
linuxdeployqt /dist/Polyhedron_3 $(find -name '*plugin*.so' -printf ' -executable=/dist/%p') -bundle-non-qt-libs -verbose=2
rm /dist/AppRun
printf '#!/bin/sh\n\nDIR=$(dirname $0)\nLD_LIBRARY_PATH=$DIR/lib;export LD_LIBRARY_PATH;$DIR/Polyhedron_3 $@\n' > /dist/AppRun
chmod a+x /dist/AppRun
cp -a /scripts/default.desktop /dist/
appimagetool /dist
