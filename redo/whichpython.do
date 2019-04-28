exec >&2

: ${PYTHON_CANDIDATES:=python2.7 python2 python}
echo "whichpython.do argv=$1 $2 $3  candidates=$PYTHON_CANDIDATES" >> logX.txt

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
        echo "found $cmd"
        echo "found $cmd writing to $3" >> logX.txt
		echo $cmd >$3
		exit 0
	fi
done
echo "nothing found!!" >> logX.txt
exit 10
