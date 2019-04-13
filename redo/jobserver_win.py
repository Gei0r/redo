"""Implementation of a jobserver for Windows"""
#
# Right now this jobserver does not support multiple jobs.

import subprocess, state

def setup(maxjobs):
    """ Start the jobserver (if it isn't already) with the given token count.

    Args:
      maxjobs: Only 0 is supported.
    """

    assert maxjobs == 0

def has_token():
    return True

def ensure_token_or_cheat(reason, cheatfunc):
    """On windows, just return immediately."""
    pass

def running():
    return False

def wait_all():
    pass

def for_return_tokens():
    pass

def start(reason, jobfunc, donefunc):
    """Start the process in argv[0], and also set env
    
    Currently this also waits for the child process to finish.

    Args:
      reason: the reason the job is running.  Usually the filename of a
        target being built.
      jobfunc:
        Must return the dictionary:
           - argv: Array of strings: index 0 is the function to execute
           - env : Dictionary string->string: Things to set in the child's
                   environment
           - cwd:  string: Working directory for the child process
           - stdout: Number: File handle where to redirect child's stdout
           - stderr: Number: File handle where to redirect child's stderr
      donefunc:
        the function(reason, return_value) to call **in the parent**
        when the subprocess exits.
    """

    assert state.is_flushed()

    p = jobfunc()  # requested params for the child process

    try:
        child = subprocess.Popen(p.get("argv"), cwd=p.get("cwd"), 
                                 env=p.get("env"),
                                 stdout=p.get("stdout"),
                                 stderr=p.get("stderr"))
    except OSError:
        # todo: additional logging?
        raise

    child.wait()

    donefunc(reason, child.returncode)
