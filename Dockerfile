FROM cgal/testsuite-docker:centos6
MAINTAINER Laurent Rineau <laurent.rineau@cgal.org>

RUN yum -y install centos-release-scl-rh && \
    yum -y install devtoolset-4-gcc-c++ \
                   /lib64/libfuse.so.2 tbb-devel.x86_64 && \
    yum -y clean all

RUN curl -SLO https://github.com/probonopd/linuxdeployqt/archive/master.tar.gz && \
    tar xf master.tar.gz && cd linuxdeployqt* && \
    qmake-qt5 linuxdeployqt.pro && \
    make -j4 && cp -a ./linuxdeployqt/linuxdeployqt /usr/bin && \
    cd .. && rm -rf linuxdeployqt* && rm master.tar.gz

RUN curl -SLO https://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.bz2 && \
    tar xf patchelf-0.9.tar.bz2 && cd patchelf-0.9 && ./configure  && make && \
    make install && cd .. && rm -rf patchelf*

RUN curl -SLO https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod a+x appimage* && ./appimagetool* --appimage-extract && \
    mv /squashfs-root/usr/bin/* /usr/bin && rm -rf /squashfs-root /appimage*

COPY qtlogging.ini /usr/share/qt5

ENTRYPOINT ["scl", "enable", "devtoolset-4"]
CMD ["bash"]
