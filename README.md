# Pre-built LLVM Binaries

This repository hosts pre-built binaries from the LLVM project, along
with infrastructure to build them.

Some details about the binaries and how they're built:

  * Included LLVM sub-projects: LLVM and Clang
  * Included LLVM backends: all
  * LLVM assertions: disabled
  * LLVM build configuration: release
  * Host OS: Windows, Mac, Linux (Ubuntu 20.04)
  * Host Architecture:
      * Windows: x86_64
      * macOS: x86_64 and ARM (M1)
      * Linux: x86_64; arm64, ppc64le (emulated with qemu)

These builds generally use minimal dependencies, which get in the way
of making portable builds later. This means that e.g., on Ubuntu, the
only dependency required to consume these binaries is
`build-essential`.

The build infrastructure is designed to share as much as possible
between the host OSes; this means for example that the Windows build
uses bash (MINGW) rather than CMD or PowerShell. Note that despite
using bash for scripting, the build is still done with Visual Studio
on Windows.

# Multiarch Builds

Multiarch builds are unfortunately infeasible to do in GitHub Actions
due to the 3-4&times; slowdown with emulation. These commands have to
be run locally with each release:

```bash
# triple=aarch64-linux-gnu arch=arm64 version=19.1.7 threads=20 ./main.sh
triple=powerpc64le-linux-gnu arch=ppc64le version=19.1.7 threads=20 ./main.sh
```
