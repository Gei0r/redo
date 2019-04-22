exec >&2
for py in python2.7 python2 python; do
	echo "Trying: $py"
	cmd=$(command -v "$py") ||

	cmd=$(echo "$cmd" | sed "s/\\\\/\\//g")  # replace backslash
	# intentionally using the 'print statement' (as opposed to print
	# function) here, to rule out any python3 interpreters
	out=$($cmd -c 'print "success"' 2>/dev/null) || true
	if [ "$out" = "success" ]; then
		echo $cmd >$3
		exit 0
	fi
done
exit 10
