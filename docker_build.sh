#!/bin/bash

set -e
set -x

if [[ -n $arch ]]; then
    export DOCKER_BUILDKIT=1
fi

docker build ${arch:+--platform=}$arch --build-arg release=$release --build-arg version=$version --build-arg triple=$triple --build-arg threads=${threads:-4} -t terralang/llvm-build:$distro-$release-llvm$version -f Dockerfile.$distro${variant:+-}$variant .

# Copy files out of container.
tmp=$(docker create terralang/llvm-build:$distro-$release-llvm$version)
docker cp $tmp:/llvm/clang+llvm-$version-$triple.tar.xz .
docker rm $tmp
