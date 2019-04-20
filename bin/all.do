exec >&2
redo-ifchange ../redo/version/all ../redo/py ../redo/sh list
xargs redo-ifchange <list

case `uname -s` in
    MSYS_NT*|CYGWIN_NT*)
        # also build .bat files on windows
        while read CMD; do
            redo-ifchange ${CMD}.bat
        done < list
esac
