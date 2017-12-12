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
find -name '*.so' -a -not -name '*plugin*.so' | xargs -l10 cp --preserve=mode --parents -t /dist/usr/lib
cp --preserve=mode Polyhedron_3 /dist/usr/bin/
cp -r --preserve=mode --parents implicit_functions/*.so /dist/usr/bin/
cp -r --preserve=mode --parents Plugins/*/*.so /dist/usr/bin/
linuxdeployqt /dist/usr/bin/Polyhedron_3  $(find -name '*plugin*.so' -printf ' -executable=/dist/usr/bin/%p') -bundle-non-qt-libs -verbose=2 -no-translations
$SHELL -$- /scripts/create_appimage.sh

