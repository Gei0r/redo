exec >&2

: ${INSTALL:=install}
: ${DESTDIR=NONE}
: ${PREFIX:=/usr}
: ${MANDIR:=$DESTDIR$PREFIX/share/man}
: ${DOCDIR:=$DESTDIR$PREFIX/share/doc/redo}
: ${BINDIR:=$DESTDIR$PREFIX/bin}
: ${LIBDIR:=$DESTDIR$PREFIX/lib/redo}

if [ "$DESTDIR" = "NONE" ]; then
	echo "$0: fatal: set DESTDIR before trying to install."
	exit 99
fi

redo-ifchange all
rm -f redo/whichpython
redo redo/whichpython
echo "~~ redo/whichpython finished" >> logY.txt
read py <redo/whichpython

echo "Installing to: $DESTDIR$PREFIX"
echo "Installing to: $DESTDIR$PREFIX" >> logY.txt

# make dirs
"$INSTALL" -d "$MANDIR/man1" "$DOCDIR" "$BINDIR" \
	"$LIBDIR" "$LIBDIR/version"

# docs
for d in docs/*.1; do
	[ "$d" = "docs/*.1" ] && continue
	"$INSTALL" -m 0644 $d "$MANDIR/man1"
done
"$INSTALL" -m 0644 README.md "$DOCDIR"

# .py files (precompiled to .pyc files for speed)
"$INSTALL" -m 0644 redo/*.py "$LIBDIR/"
"$INSTALL" -m 0644 redo/version/*.py "$LIBDIR/version/"
"$py" -mcompileall "$LIBDIR"

# It's important for the file to actually be named 'sh'.  Some shells (like
# bash and zsh) only go into POSIX-compatible mode if they have that name.
case `uname -s` in
    MSYS_NT*|CYGWIN_NT*)
        cp -R redo/sh.exe "$LIBDIR/sh.exe"
        ;;
    Windows_NT*)  # busybox-w32
        # busybox-w32 doesn't support copying symlinks, so we copy the
        # symlinks' target (which in this case will be the busybox executable)
        cp `readlink -f redo/sh.exe` "$LIBDIR/sh.exe"
        ;;
    *)
        cp -R redo/sh "$LIBDIR/sh"
esac


# binaries
bins=$(ls bin/redo* | grep '^bin/redo[-a-z]*\(\.bat\)\?$')
"$INSTALL" -m 0755 $bins "$BINDIR/"
