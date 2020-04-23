#!/bin/sh
source /opt/rh/devtoolset-7/enable

set -e

[ -d /build ] || mkdir /build
cd /build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MODULE_LINKER_FLAGS=-pthread -DCMAKE_EXE_LINKER_FLAGS=-pthread -DCMAKE_CXX_FLAGS_RELEASE="-O3  -ftemplate-backtrace-limit=0 -std=c++14" -DWITH_demos=TRUE -DENABLE_MESH_3_IN_CLIPPING_SNAPPING=ON /cgal
make -C /build/demo/Polyhedron $@

