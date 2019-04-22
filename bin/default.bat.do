cat >$3 <<-EOF
	@echo off
	python %~dp0/$2 %*
EOF
