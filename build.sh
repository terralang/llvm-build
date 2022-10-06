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

mkdir build install
cd build
if [[ $(uname) = MINGW* ]]; then
    export CMAKE_GENERATOR="Visual Studio 17 2022"
    export CMAKE_GENERATOR_PLATFORM=x64
    export CMAKE_GENERATOR_TOOLSET="host=x64"
fi
cmake ../llvm-project-$version.src/llvm -DCMAKE_INSTALL_PREFIX=$PWD/../install -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_ZSTD=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_ASSERTIONS=OFF -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV -DLLVM_ENABLE_DUMP=ON
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
    if command -v xz &> /dev/null; then
        tar cfv clang+llvm-$version-$triple.tar clang+llvm-$version-$triple
        xz -T ${threads:-4} clang+llvm-$version-$triple.tar
    else
        tar cfJv clang+llvm-$version-$triple.tar.xz clang+llvm-$version-$triple
    fi
fi
