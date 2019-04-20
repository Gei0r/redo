redo-ifchange ../flush-cache
rm -f src
: >src

for iter in 10 20; do
	rm -rf y
	rm -f x *.dyn static
	mkdir y
	: >y/static
	case `uname -s` in
		MSYS_NT*|CYGWIN_NT*)
			# The following 'ln' doesn't work on windows ("Permission denied"),
			# even if winsymlinks:nativestrict is activated.
			# So we use the native command for that.
			cmd //c mklink //D y\\x . > /dev/null
			;;
		*)
			ln -s . y/x
	esac

	../flush-cache

	(
		cd y/x/x/x/x/x
		IFS=$(printf '\n')
		redo-ifchange static x/x/x/static $PWD/static \
			$(/bin/pwd)/static /etc/fstab
		redo-ifchange $PWD/../static 2>/dev/null && exit 35
		redo-ifchange 1.dyn x/x/x/2.dyn $PWD/3.dyn \
			 $PWD/../4.dyn $(/bin/pwd)/5.dyn
	)
	[ -e y/1.dyn ] || exit $((iter + 1))
	[ -e y/2.dyn ] || exit $((iter + 2))
	[ -e y/3.dyn ] || exit $((iter + 3))
	[ -e 4.dyn ]   || exit $((iter + 4))
	[ -e y/5.dyn ] || exit $((iter + 5))

	# Second iteration won't work in minimal/do since it only ever
	# builds things once.
	. ../skip-if-minimal-do.sh
done
