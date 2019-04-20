cat >$3 <<-EOF
	@echo off
	rem We need python version 2. Try to find a matching interpreter...
	where python2 >NUL 2>&1
	if ERRORLEVEL 1 (
	    rem python2 is not in path, try "python"
	    where python >NUL 2>&1
	    if ERRORLEVEL 1 (
	        rem python is also not in path.
	        echo Python version 2 is required.
	        exit /b 255
	    ) else (
	        rem 'python' is in path, check if it's version 2
	        python --version 2>&1 | find /i "Python 2" > NUL
	        if ERRORLEVEL 1 (
	            echo Python found, but wrong version. Need version 2.
	        ) else (
	            rem 'python' is version 2. We can use it.
	            python %~dp0/$2 %*
	        )
	    )
	) else (
	    rem python2 is available in path, let's assume it's usable.
	    python2 %~dp0/$2 %*
	)
EOF
