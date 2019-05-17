# redo on Microsoft Windows

Support for Microsoft Windows is experimental.
It is generally usable, but lacks some features that are available on Unix-like
operating systems:

- It's pretty slow. A big part of it is that starting processes is a lot slower
  on Windows than it is on *nix.
  It's exacerbated by the next point.
- Parallel builds (`-j` command line switch) are not supported.
- `redoconf` is not supported.
- Due to limitations of their windows implementations, not all shells are fully
  supported.

## Prerequisites and HowTo

### Using redo

If you only want to use `redo`, you can download pre-built version from 
[Appveyor](https://ci.appveyor.com/api/projects/Gei0r/redo/artifacts/inst%2FBuilt files for windows.zip?job=Image: Visual Studio 2017).

This zip file contains [busybox-w32](https://frippery.org/busybox/) which redo
uses to run the `.do` scripts.
You can substitute your own shell by replacing `lib/redo/sh.exe` (consider
using a symlink).

The only prerequisite is that you need to have a version of Python 2 in PATH.
For instance, you can install it from
[python.org](https://www.python.org/downloads/windows/)
or via [MSYS2](https://www.msys2.org/): `pacman -S msys/python2`.

### Building redo

You will need:
- Python 2 in PATH
- A bash shell, for example:
  - the one that's included in 
    [git for Windows](https://git-scm.com/download/win)
  - the one that comes with MSYS2
- Symlink support must be enabled in Windows *and activated in bash*.
  [Instructions](https://www.joshkel.com/2018/01/18/symlinks-in-windows/)
  
You have to set the following environment variables:
- `DESTDIR`: "Install" destination directory. This can be a relative path, like
  "inst"
- `SHELL_CANDIDATES` is a space-separated list of shells to consider.
  `bash` and `busybox` will work. If you don't set the variable, the build
  system will automatically chose `dash`, which will not work on windows
  because of a [bug](https://github.com/msys2/MSYS2-packages/issues/1635) in
  `dash`.
- optional: `PYTHON_CANDIDATES` can be set to select a specific python
  executable (must be version 2). Default: Auto-detect from `PATH`.

### Running tests

You will need the same prerequisites that are required for building `redo` on
windows. 
Additionally, the tests will not run with `busybox` because it does not support
symlinks (which are required for the tests).
