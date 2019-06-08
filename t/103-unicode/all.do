case $(uname -s) in
    MSYS_NT*|MINGW64_NT*|CYGWIN_NT*|Windows_NT*)
    # Apparently, unicode support for the environment of subprocess on
    # python2 on windows is completely broken:
    # https://stackoverflow.com/a/29429496/2192139
    # So we skip this test on windows.
        ;;
    *)
        redo unicode
esac
