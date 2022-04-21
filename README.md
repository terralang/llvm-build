# Pre-built LLVM Binaries

This repository hosts pre-built binaries from the LLVM project, along
with infrastructure to build them.

Some details about the binaries and how they're built:

  * Included LLVM sub-projects: LLVM and Clang
  * Included LLVM backends: all
  * LLVM assertions: disabled
  * LLVM build configuration: release
  * Host OS: Windows, Mac, Linux (Ubuntu 18.04)
  * Host Architecture: x86_64

These builds generally use minimal dependencies, which get in the way
of making portable builds later. This means that e.g., on Ubuntu, the
only dependency required to consume these binaries is
`build-essential`.

The build infrastructure is designed to share as much as possible
between the host OSes; this means for example that the Windows build
uses bash (MINGW) rather than CMD or PowerShell. Note that despite
using bash for scripting, the build is still done with Visual Studio
on Windows.
