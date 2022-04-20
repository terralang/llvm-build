#!/bin/bash

set -e
set -x

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

if [[ $(uname) = Linux ]]; then
    # Build in a Docker container to ensure we minimize dependencies.
    export distro=ubuntu
    export release=18.04
    ./docker_build.sh
else
    ./build.sh
fi
