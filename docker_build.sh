#!/bin/bash

set -e

docker build --build-arg release=$release --build-arg version=$version --build-arg triple=$triple --build-arg threads=${threads:-4} -t terralang/llvm-build:$distro-$release-llvm$version -f Dockerfile.$distro .

# Copy files out of container.
tmp=$(docker create terralang/terra:$distro-$release-llvm$version)
docker cp $tmp:/llvm .
docker rm $tmp
