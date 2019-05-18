exec >&2
redo-ifchange ../redo/version/all ../redo/py list
case $(uname -s) in
    MSYS_NT*|MINGW64_NT*|CYGWIN_NT*|Windows_NT*)
        redo-ifchange ../redo/sh.exe
        ;;
    *)
        redo-ifchange ../redo/sh
esac

xargs redo-ifchange <list

case $(uname -s) in
    MSYS_NT*|MINGW64_NT*|CYGWIN_NT*|Windows_NT*)
        # also build .bat files on windows
        while read CMD; do
            redo-ifchange ${CMD}.bat
        done < list
esac
