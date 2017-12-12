#!/bin/sh

set -e
cp /scripts/cgal_logo_ipe_2013.png /dist/default.png
cp /scripts/default.desktop /dist/
cd /results
appimagetool -v /dist
