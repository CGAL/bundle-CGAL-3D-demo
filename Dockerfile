FROM cgal/testsuite-docker:centos6
MAINTAINER Laurent Rineau <laurent.rineau@cgal.org>

RUN yum -y install centos-release-scl-rh && \
    yum -y install devtoolset-4-gcc-c++ \
                   /lib64/libfuse.so.2 \
                   git libgl1-mesa-dev opencv && \
    yum -y clean all

RUN curl -SLO https://github.com/probonopd/linuxdeployqt/archive/master.tar.gz && \
    tar xf master.tar.gz && cd linuxdeployqt-master/ && \
    export PATH=$(readlink -f /tmp/.mount_QtCreator-*-x86_64/*/gcc_64/bin/):$PATH && \
    qmake-qt5 linuxdeployqt.pro && \
    make -j4 && make -j4 install && \
    cd .. && rm -rf linuxdeployqt* && rm master.tar.gz

RUN curl -SLO https://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.bz2 && \
    tar xf patchelf-0.9.tar.bz2 && cd patchelf-0.9 && ./configure  && make && \
    make install && cd .. && rm -rf patchelf*

RUN curl -SLO https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimage* && ./appimagetool* --appimage-extract && \
    mv /squashfs-root/usr/bin/* /usr/bin && rm -rf /squashfs-root /appimage*

RUN curl -SLO https://www.threadingbuildingblocks.org/sites/default/files/software_releases/linux/tbb44_20160803oss_lin.tgz && \
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
 && cmake -DCMAKE_CXX_COMPILER:FILEPATH=/opt/rh/devtoolset-4/root/usr/bin/g++ -DCMAKE_CXX_FLAGS=-std=c++11 . \
 && make -j "$(nproc)" \
 && make install \
 && cd .. \
 && rm -rf LAStools-master 


COPY qtlogging.ini /usr/share/qt5

ENTRYPOINT ["scl", "enable", "devtoolset-4"]
CMD ["bash"]
