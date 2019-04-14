exec >$3
if [[ `uname -s` == MSYS_NT* ]]; then
    cat<<EOF
        # On windows, we don't have a file for stdout unfortunately
        cc -Wall -o "\$2" -c "\$1"
EOF
else
    cat <<-EOF
    	cc -Wall -o /dev/fd/1 -c "\$1"
EOF
fi
chmod a+x $3
