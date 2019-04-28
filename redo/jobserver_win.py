"""Implementation of a jobserver for Windows"""
#
# Right now this jobserver does not support multiple jobs.

import subprocess, state, sys, helpers

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

def force_return_tokens():
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
    helpers.mylog("jobserver_win start(reason=" + reason + ")")
    assert state.is_flushed()

    p = jobfunc()  # requested params for the child process

    try:
        helpers.mylog('starting ' + ' '.join(p.get('argv')) + "   cwd: " + p.get("cwd"))
        child = subprocess.Popen(p.get("argv"), cwd=p.get("cwd"), 
                                 env=p.get("env"),
                                 stdout=p.get("stdout"),
                                 stderr=p.get("stderr"))
    except OSError:
        logs.err('Could not start: ' + " ".join(p.get("argv")))
        logs.err('cwd: ' + p.get(cwd))
        raise

    helpers.mylog("waiting for " + p.get("argv")[0] + "...")
    child.wait()
    helpers.mylog("subprocess finished: " + p.get("argv")[0] + \
                  " rv=" + str(child.returncode))

    donefunc(reason, child.returncode)

def isWindows():
    return True
