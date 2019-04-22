redo-ifchange ../redo/whichpython
read py <../redo/whichpython
py=$(cygpath -w $py)
cat >$3 <<-EOF
	@echo off
	$py %~dp0/$2 %*
EOF
