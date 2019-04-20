cat >$3 <<-EOF
	@echo off
	rem We need python version 2. Try to find a matching interpreter...
	python2 --version 2>&1 | find /i "Python 2" > NUL
	if %ERRORLEVEL% == 0 (
	    rem python2 is usable.
	    python2 %~dp0/$2 %*
	) else (
	    rem python2 is not usable. Try plain python:
	    python --version 2>&1 | find /i "Python 2" > NUL
	    if %ERRORLEVEL% == 0 (
	        rem plain "python" is python2. So we can use that.
	        python %~dp0/$2 %*
	    ) else (
	        echo "Python 2 is required."
	        exit 255
	    )
	)
EOF
