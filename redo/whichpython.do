exec >&2
for py in python2.7 python2 python; do
	echo "Trying: $py"
	# The "||" and the following echo are required on some windows
	# environments, don't know why.
	cmd=$(command -v "$py") || 
	echo "$cmd" > /dev/null
	# intentionally using the 'print statement' (as opposed to print
	# function) here, to rule out any python3 interpreters
	out=$($cmd -c 'print "success"' 2>/dev/null) || true
	if [ "$out" = "success" ]; then
		echo $cmd >$3
		exit 0
	fi
done
exit 10
