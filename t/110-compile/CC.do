exec >$3
case `uname -s` in
    MSYS_NT*|MINGW64_NT*|CYGWIN_NT*|Windows_NT*)
        cat<<-EOF
			# On windows, we don't have a file for stdout unfortunately
			cc -Wall -o "\$2" -c "\$1"
		EOF
        ;;
    *)
		cat <<-EOF
    		cc -Wall -o /dev/fd/1 -c "\$1"
		EOF
esac

chmod a+x $3
