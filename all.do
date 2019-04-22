if [ "$1,$2" != "all,all" ]; then
	echo "ERROR: old-style redo args detected: don't use --old-args." >&2
	exit 1
fi

# Do this first, to ensure we're using a good shell
case `uname -s` in
    MSYS_NT*|CYGWIN_NT*)
        redo-ifchange redo/sh.exe
        ;;
    *)
        redo-ifchange redo/sh
esac

redo-ifchange bin/all docs/all
