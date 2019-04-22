exec >&2

: ${PYTHON_CANDIDATES:=python2.7 python2 python}

for py in $PYTHON_CANDIDATES; do
	echo "Trying: $py"
	set +e
	cmd=$(command -v "$py")
	set -e

	cmd=$(echo "$cmd" | sed "s/\\\\/\\//g")  # replace backslash
	# intentionally using the 'print statement' (as opposed to print
	# function) here, to rule out any python3 interpreters
	out=$($cmd -c 'print "success"' 2>/dev/null) || true
	if [ "$out" = "success" ]; then
		echo "will use $cmd"
		echo $cmd >$3
		exit 0
	fi
done
exit 10
