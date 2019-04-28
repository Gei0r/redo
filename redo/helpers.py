"""Some helper functions that don't fit anywhere else."""
import os, errno

if os.name != 'nt':
    import fcntl

class ImmediateReturn(Exception):
    def __init__(self, rv):
        Exception.__init__(self, "immediate return with exit code %d" % rv)
        self.rv = rv


def unlink(f):
    """Delete a file at path 'f' if it currently exists.

    Unlike os.unlink(), does not throw an exception if the file didn't already
    exist.
    """
    try:
        os.unlink(f)
    except OSError, e:
        if e.errno == errno.ENOENT:
            pass  # it doesn't exist, that's what you asked for


def close_on_exec(fd, yes):
    if os.name != 'nt':
        fl = fcntl.fcntl(fd, fcntl.F_GETFD)
        fl &= ~fcntl.FD_CLOEXEC
        if yes:
            fl |= fcntl.FD_CLOEXEC
            fcntl.fcntl(fd, fcntl.F_SETFD, fl)
            
def mylog(msg):
    try:
        f = open("/d/temp/logX.txt", "a")
    except IOError:
        f = open("D:/temp/logX.txt", "a")

    f.write(msg + "\n")
    f.close()

def fd_exists(fd):
    if os.name == 'nt':
        try:
            os.fstat(fd)
            return True
        except OSError:
            return False
            
    try:
        fcntl.fcntl(fd, fcntl.F_GETFD)
    except IOError:
        return False
    return True

def fixPath_winPosix(p):
    """ Some python installations on windows think they're running on posix,
    which means the expect unix-style paths (/c/windows/...).
    Sometimes, they will encounter windows-style paths, however
    (C:\windows\...), which will confuse them.
    This function will transform windows-style paths to unix-style paths if the
    os.name is 'posix', otherwise it will do nothing.

    A windows-style path is detected by the second and third char being :\
    """
    if os.name == 'posix' and len(p) >= 3 and \
       (p[1:3] == ':\\' or p[1:3] == ":/"):
        p = "/" + p[0].lower() + p[2:].replace("\\", "/")
    return p
