exec >&2
for py in python2.7 python2 python; do
	echo "Trying: $py"
	case `uname -s` in
		MSYS_NT*|CYGWIN_NT*)
            # unfortunately, the "command" call doesn't work on windows, even
            # though the call is available and works on its own
			cmd="$py"
			;;
		*)
			cmd=$(command -v "$py")
	esac

	# intentionally using the 'print statement' (as opposed to print
	# function) here, to rule out any python3 interpreters
	out=$($cmd -c 'print "success"' 2>/dev/null) || true
	if [ "$out" = "success" ]; then
		echo $cmd >$3
		exit 0
	fi
done
exit 10
