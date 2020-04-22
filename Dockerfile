FROM cgal/testsuite-docker:centos7
MAINTAINER Laurent Rineau <laurent.rineau@cgal.org>

RUN yum -y install centos-release-scl-rh && \
    yum -y install devtoolset-7-gcc-c++ \
                   fuse-libs fuse-libs libXt-devel metis-devel opencv-devel libgfortran4 bzip2-devel doxygen bzip2 \
                   git mesa-libGL-devel file && \
    yum -y remove tbb-devel && \
    yum -y clean all

    
RUN git clone https://github.com/probonopd/linuxdeployqt.git && cd linuxdeployqt && git checkout 4 && \
    export PATH=$(readlink -f /tmp/.mount_QtCreator-*-x86_64/*/gcc_64/bin/):$PATH && \
    qmake-qt5 linuxdeployqt.pro && \
    make -j4 && cd /usr/bin && ln -s /linuxdeployqt/linuxdeployqt/linuxdeployqt . 

RUN curl -SLO https://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.bz2 && \
    tar xf patchelf-0.9.tar.bz2 && cd patchelf-0.9 && ./configure  && make && \
    make install && cd .. && rm -rf patchelf*

RUN curl -SLO https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimage* && ./appimagetool* --appimage-extract && \
    mv /squashfs-root/usr/bin/* /usr/bin && mv /squashfs-root/usr/lib/* /usr/lib && rm -rf /squashfs-root /appimage*

RUN curl -SLO https://github.com/oneapi-src/oneTBB/releases/download/2018_U5/tbb2018_20180618oss_lin.tgz && \
    tar -C /opt -xf tbb*.tgz && \
    rm tbb*tgz

ENV TBBROOT=/opt/tbb44_20160803oss TBB_ARCH_PLATFORM=intel64/gcc4.4


RUN curl -s -SL http://www.vtk.org/files/release/6.3/VTK-6.3.0.tar.gz | tar xz && \
    cd VTK-6.3.0 && \
    cmake . && \
    make -j2 && \
    make -j 2 install && \
    cd .. && rm -rf VTK-6.3.0

RUN curl -s -SL https://github.com/CGAL/LAStools/archive/master.tar.gz | tar xz \
 && cd ./LAStools-master \
 && cmake -DCMAKE_CXX_COMPILER:FILEPATH=/opt/rh/devtoolset-7/root/usr/bin/g++ -DCMAKE_CXX_FLAGS=-std=c++11 . \
 && make -j "$(nproc)" \
 && make install \
 && cd .. \
 && rm -rf LAStools-master 

RUN curl -s -SL http://sourceforge.net/projects/boost/files/boost/1.67.0/boost_1_67_0.tar.gz | tar xz && \
    cd boost_1_67_0 && \
    ./bootstrap.sh --without-libraries=graph_parallel,python,locale,mpi,signals,wave && \
    ./b2 -d0 --prefix=/usr/local/ install && \
    cd .. && rm -rf boost_*

#RUN curl -SLO https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Linux-x86_64.sh && bash cmake-3.17.1-Linux-x86_64.sh --skip-license && rm -rf cmake-3.17.1-Linux-x86_64.sh

RUN curl -s -SL http://ftp.gnu.org/gnu/glpk/glpk-4.35.tar.gz | tar xz && cd glpk-4.35 && ./configure && make && make install && cd .. && rm -rf glpk-4.35

RUN git clone https://github.com/STORM-IRIT/OpenGR.git && cd OpenGR && mkdir build && cd build && cmake -DOpenGR_COMPILE_APPS=OFF -DOpenGR_COMPILE_TESTS=OFF -DBUILD_TESTING=OFF -DCMAKE_CXX_COMPILER:FILEPATH=/opt/rh/devtoolset-7/root/usr/bin/g++ -DCMAKE_CXX_FLAGS=-std=c++11 .. && make && make install && cd ../.. && rm -rf OpenGR

RUN git clone https://github.com/ethz-asl/libnabo.git && cd libnabo && mkdir build && cd build && cmake -DCMAKE_CXX_COMPILER:FILEPATH=/opt/rh/devtoolset-7/root/usr/bin/g++ -DCMAKE_CXX_FLAGS=-std=c++11 .. && make  && make install && cd ../.. && rm -rf libnabo

RUN git clone https://github.com/ethz-asl/libpointmatcher.git && cd libpointmatcher && mkdir build && cd build && cmake -DCMAKE_CXX_COMPILER:FILEPATH=/opt/rh/devtoolset-7/root/usr/bin/g++ -DEIGEN_INCLUDE_DIR=/usr/include/eigen3/ -DCMAKE_CXX_FLAGS=-std=c++11 .. && make && make install && cd ../.. && rm -rf libpointmatcher

COPY qtlogging.ini /usr/share/qt5
COPY scripts /scripts

ENV TBBROOT=/opt/tbb2018_20180618oss TBB_ARCH_PLATFORM=intel64/gcc4.4
#ENTRYPOINT ["scl", "enable", "devtoolset-7"]
ENTRYPOINT ["/scripts/docker_entrypoint.sh"]
