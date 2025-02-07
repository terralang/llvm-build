#!/bin/bash

set -e
set -x

if [[ -z $triple ]]; then
    arch=$(uname -m | sed -e s/arm64/aarch64/)
    if [[ $(uname) = Linux ]]; then
        export triple=${arch}-linux-gnu
    elif [[ $(uname) = Darwin ]]; then
        export triple=${arch}-apple-darwin
    elif [[ $(uname) = MINGW* ]]; then
        export triple=${arch}-windows-msvc17
    else
        echo "Don't recognize this platform."
        exit 1
    fi
fi

if [[ $(uname) = Linux ]]; then
    # Build in a Docker container to ensure we minimize dependencies.
    export distro=ubuntu
    export release=20.04
    ./docker_build.sh
else
    ./build.sh
fi
