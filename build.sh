#!/bin/bash

set -e
set -x

curl -L -O https://github.com/llvm/llvm-project/releases/download/llvmorg-$version/llvm-project-$version.src.tar.xz
uname
if [[ $(uname) = MINGW* ]]; then
    7z x -y llvm-project-$version.src.tar.xz
    7z x -y llvm-project-$version.src.tar
else
    tar xf llvm-project-$version.src.tar.xz
fi
rm llvm-project-$version.src.tar*

cmake_flags=(
    -DCMAKE_INSTALL_PREFIX="$PWD/install"
    -DCMAKE_BUILD_TYPE=Release
    -DLLVM_ENABLE_TERMINFO=OFF
    -DLLVM_ENABLE_LIBEDIT=OFF
    -DLLVM_ENABLE_ZLIB=OFF
    -DLLVM_ENABLE_ZSTD=OFF
    -DLLVM_ENABLE_LIBXML2=OFF
    -DLLVM_ENABLE_ASSERTIONS=OFF
)

mkdir build install
cd build
if [[ $(uname) = MINGW* ]]; then
    export CMAKE_GENERATOR="Visual Studio 17 2022"
    export CMAKE_GENERATOR_PLATFORM=x64
    export CMAKE_GENERATOR_TOOLSET="host=x64"
    cmake_flags+=(
        -DLLVM_ENABLE_PROJECTS=clang
    )
else
    cmake_flags+=(
        -DLLVM_ENABLE_PROJECTS='clang;lld'
        -DLLVM_ENABLE_RUNTIMES=libunwind
    )
fi
cmake ../llvm-project-$version.src/llvm "${cmake_flags[@]}"
if [[ $(uname) = MINGW* ]]; then
    cmake --build . --target INSTALL --config Release -j${threads:-4}
else
    make install -j${threads:-4}
fi
cd ..
rm -rf build llvm-project-$version.src*

mv install clang+llvm-$version-$triple
if [[ $(uname) = MINGW* ]]; then
    7z a -t7z clang+llvm-$version-$triple.7z clang+llvm-$version-$triple
else
    tar cfzv clang+llvm-$version-$triple.tar.gz clang+llvm-$version-$triple
fi
