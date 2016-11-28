#!/bin/sh

set -e
PATH=/usr/lib64/qt5/bin:$PATH
export PATH

[ -d /dist ] || mkdir /dist
cd /build/demo/Polyhedron
find -name '*.so' | xargs -l10 cp --parents -t /dist
cp Polyhedron_3 /dist/
linuxdeployqt /dist/Polyhedron_3 $(find -name '*plugin*.so' -printf ' -executable=/dist/%p') -bundle-non-qt-libs -verbose=2
cp -a /lib64/libudev.so* /dist/lib
