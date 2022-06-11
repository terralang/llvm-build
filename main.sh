#!/bin/bash

set -e
set -x

if [[ -z $triple ]]; then
    if [[ $(uname) = Linux ]]; then
        export triple=x86_64-linux-gnu
    elif [[ $(uname) = Darwin ]]; then
        export triple=x86_64-apple-darwin
    elif [[ $(uname) = MINGW* ]]; then
        export triple=x86_64-windows-msvc17
    else
        echo "Don't recognize this platform."
        exit 1
    fi
fi

if [[ $(uname) = Linux ]]; then
    # Build in a Docker container to ensure we minimize dependencies.
    export distro=ubuntu
    if [[ -z $arch || $arch = arm64 ]]; then
        export release=18.04
        export variant=cmake # Need newer CMake. Get it from Kitware binaries.
    else
        # Kitware does not provide CMake builds for all platforms, so
        # we need a newer Ubuntu to get the necessary CMake dependency.
        export release=20.04
    fi
    ./docker_build.sh
else
    ./build.sh
fi
