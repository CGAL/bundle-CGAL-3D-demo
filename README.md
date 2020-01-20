# `docker.io/cgal/bundle-3d-demo` [![Build Status]][status-img]
Automatic building of the CGAL 3D demo (Polyhedron Demo)

## Overview

A simple command line to build the demo from `$HOME/Git/cgal`, and put it
in the `results/` sub-directory of your current working-directory:

```shell
docker run --rm -v $PWD/results:/results:Z -v ~/Git/cgal:/cgal:ro docker.io/cgal/bundle-3d-demo  `/scripts/build.sh -j6 && /scripts/deploy.sh'
```

## Usage

### Container Directories

The container scripts uses those directories:

- `/cgal/` is the location of CGAL sources. It can be either a Git checkout
  of a CGAL branch, or an extracted tarball.
- `/build/` is the binary directory used during the compilation. In
  particular `/build/demo/Polyhedron/` will be the binary tree of the demo.
- `/scripts/` contains the two scripts used to build and create the
  AppImage of the demo:
  - `/scripts/build.sh`
  - `/scripts/deploy.sh`
- `/dist/` is the AppDir created by [`linuxdeployqt`] before [`appimagetool`]
  is called.
- `/results/` is the output directory where the AppImage binary will be
  created.

Directories you should mount as Docker volumes:

  - `/cgal/`, as a read-only volume, because that is the input of the
    scripts, and
  - `/results/`, as a read-write volume, to get an easy access to the
    result.

Directories that can be mounted as Docker volumes for debugging purpose:

  - `/build/` (read-write) if you want to avoid rebuilding the full demo
    between two runs of the container,
  - `/scripts/` (read-only) if you want to debug the scripts,
  - `/dist/` if you want to debug issues with `linuxdeployqt`.

### The Main Command
The entrypoint of the container is `["scl", "enable",
"devtoolset-4"]`. That command only accept one extra option, that is
interpreted by a shell. Quote it with single-quotes (`'`).

For example, a possible debugging command line is:

```shell
docker run --rm -t -i -v $PWD/build:/build:Z -v $PWD/results:/results:Z -v $PWD/scripts:/scripts:ro -v $PWD/dist:/dist:Z -v ~/Git/cgal:/cgal:ro docker.io/cgal/bundle-3d-demo  'bash -x /scripts/build.sh -j6 VERBOSE=1 && bash -x /scripts/deploy.sh'
```

The extra `:Z` option to volume specification is used on Linux version
where docker-selinux is enabled. It allows the container to write to the directory.

[Build Status]: https://travis-ci.org/lrineau/bundle-CGAL-3D-demo.svg?branch=master
[status-img]: https://travis-ci.org/lrineau/bundle-CGAL-3D-demo
[`linuxdeployqt`]: https://github.com/probonopd/linuxdeployqt
[`appimagetool`]: https://github.com/probonopd/AppImageKit
