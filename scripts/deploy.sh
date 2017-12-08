#!/bin/sh

set -e
PATH=/usr/lib64/qt5/bin:$PATH
export PATH

[ -d /dist ] || mkdir /dist
[ -d /dist/usr ] || mkdir /dist/usr
[ -d /dist/usr/bin ] || mkdir /dist/usr/bin
[ -d /dist/usr/lib ] || mkdir -p /dist/usr/lib
[ -d /results ] || mkdir /results
cd /build/demo/Polyhedron
find -name '*.so' | xargs -l10 cp --preserve=mode --parents -t /dist/usr/lib
cp --preserve=mode Polyhedron_3 /dist/usr/bin/
cp -r --preserve=mode Plugins/*/*.so /dist/usr/bin/
linuxdeployqt /dist/usr/bin/Polyhedron_3  $(find -name '*plugin*.so' -printf ' -executable=/dist/usr/bin/%p') -bundle-non-qt-libs -verbose=2 -no-translations
rm -f /dist/AppRun
printf '#!/bin/sh\n\ncd ./usr/bin/\nLD_LIBRARY_PATH=$PWD:$PWD/../lib;export LD_LIBRARY_PATH;$PWD/Polyhedron_3\n $@\n' > /dist/AppRun
chmod a+x /dist/AppRun
cp --preserve=mode -a /scripts/cgal_logo_ipe_2013.png /dist/default.png
cp --preserve=mode -a /scripts/default.desktop /dist/
cd /results
appimagetool -v /dist
