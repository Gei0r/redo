cat >$3 <<-EOF
	@echo off
	python2 %~dp0/$2 %*
EOF
