#!/bin/bash

set -e
set -x

curl -L -O https://github.com/llvm/llvm-project/releases/download/llvmorg-$version/llvm-$version.src.tar.xz
curl -L -O https://github.com/llvm/llvm-project/releases/download/llvmorg-$version/clang-$version.src.tar.xz
uname
if [[ $(uname) = MINGW* ]]; then
    7z x -y llvm-$version.src.tar.xz
    7z x -y llvm-$version.src.tar
    7z x -y clang-$version.src.tar.xz
    7z x -y clang-$version.src.tar
else
    tar xf llvm-$version.src.tar.xz
    tar xf clang-$version.src.tar.xz
fi
mv clang-$version.src llvm-$version.src/tools/clang

mkdir build install
cd build
if [[ $(uname) = MINGW* ]]; then
    export CMAKE_GENERATOR="Visual Studio 17 2022"
    export CMAKE_GENERATOR_PLATFORM=x64
    export CMAKE_GENERATOR_TOOLSET="host=x64"
fi
cmake ../llvm-$version.src -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_ASSERTIONS=OFF
if [[ $(uname) = MINGW* ]]; then
    cmake --build . --target INSTALL --config Release -j${threads:-4}
else
    make install -j${threads:-4}
fi
cd ..
rm -rf build llvm-$version.src* clang-$version.src*

mv install clang+llvm-$version-$triple
if [[ $(uname) = MINGW* ]]; then
    7z a -t7z clang+llvm-$version-$triple.7z clang+llvm-$version-$triple
else
    tar cfJv clang+llvm-$version-$triple.tar.xz clang+llvm-$version-$triple
fi
