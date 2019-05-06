exec >&2

case `uname -s` in
	MSYS_NT*|MINGW64_NT*|CYGWIN_NT*|Windows_NT*)
		read -d '' fixwinpath <<-EOF || true

			# Some python version on windows (e.g. msys64/usr/bin/python2.7) think they
			# run on posix, which means they work with unix-style paths (/c/windows/...).
			# However, a shell might pass argv[0] windows-style (C:\windows\...), which
			# would completely confuse python.
			# So we fix the path here. We could use the cygpath tool, but this is faster
			if os.name == 'posix' and len(sys.argv[0]) >= 3 and sys.argv[0][1:3] == ':\\\\\\\':
			    sys.argv[0] = "/" + sys.argv[0][0] + sys.argv[0][2:].replace("\\\\\\\", "/").replace("//", "/")

		EOF
        ;;
    *)
        fixwinpath=""
esac

case $1 in
	redo-sh)
		redo-ifchange ../redo/sh
		cat >$3 <<-EOF
			#!/bin/sh
			d=\$(dirname "\$0")/..
			[ -x \$d/lib/redo/sh ] && exec \$d/lib/redo/sh "\$@"
			[ -x \$d/redo/sh ] && exec \$d/redo/sh "\$@"
			echo "\$0: fatal: can't find \$d/lib/redo/sh or \$d/redo/sh" >&2
			exit 98
		EOF
		chmod a+x "$3"
		;;
	redo|redo-*)
		redo-ifchange ../redo/whichpython
		read py <../redo/whichpython
		cmd=${1#redo-}
		cat >$3 <<-EOF
			#!$py
			import sys, os;
			$fixwinpath
			exe = os.path.realpath(os.path.abspath(sys.argv[0]))
			exedir = os.path.dirname(exe)
			sys.path.insert(0, os.path.join(exedir, '../lib'))
			sys.path.insert(0, os.path.join(exedir, '..'))
			import redo.title
			import redo.cmd_$cmd
			redo.title.auto()
			redo.cmd_$cmd.main()
		EOF
		chmod a+x "$3"
		;;
	*) echo "$0: don't know how to build '$1'" >&2; exit 99 ;;
esac
