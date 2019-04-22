exec >&2
redo-ifchange ../redo/version/all ../redo/py list
uname -s
case `uname -s` in
    MSYS_NT*|CYGWIN_NT*)
        redo-ifchange ../redo/sh.exe
        ;;
    *)
        redo-ifchange ../redo/sh
esac

xargs redo-ifchange <list

case `uname -s` in
    MSYS_NT*|CYGWIN_NT*)
        # also build .bat files on windows
        while read CMD; do
            redo-ifchange ${CMD}.bat
        done < list
esac
