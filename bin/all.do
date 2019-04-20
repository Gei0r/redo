exec >&2
redo-ifchange ../redo/version/all ../redo/py ../redo/sh list
xargs redo-ifchange <list

if [[ `uname -s` == MSYS_NT* ]]; then
    # also build .bat files on windows
    while read CMD; do
        redo-ifchange ${CMD}.bat
    done < list
fi
