#!/bin/sh

set -e
cp --preserve=mode -a /scripts/cgal_logo_ipe_2013.png /dist/default.png
cp --preserve=mode -a /scripts/default.desktop /dist/
cd /results
appimagetool -v /dist
