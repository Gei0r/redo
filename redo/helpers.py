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
    if os.name != 'nt':  # not supported on windows
        fl = fcntl.fcntl(fd, fcntl.F_GETFD)
        fl &= ~fcntl.FD_CLOEXEC
        if yes:
            fl |= fcntl.FD_CLOEXEC
            fcntl.fcntl(fd, fcntl.F_SETFD, fl)
            
def mylog(msg):
    try:
        f = open("/d/temp/logX.txt", "a")
    except IOError:
        try:
            f = open("D:/temp/logX.txt", "a")
        except IOError:
            f = open("~/logX.txt", "a")

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

def which_win(name):
    """ Try to find $name.exe or $name.bat in PATH.
    Returns the absolute path to the .exe or .bat file.
    The current directory ('.') is implicitly at the front of PATH.

    Raises IOError if name is not found.

    On windows, subprocess.Popen() does not search PATH for the executable.
    Additionally, os.spawn*p() functions are not available, so we have to
    search PATH ourselves.
    """

    if(name.endswith('.exe') or name.endswith('.bat')):
        name = name[0:-5]

    # search cwd ('.') first.
    if os.access(name + ".exe", os.X_OK):
        return os.path.abspath(name + ".exe")
    if os.access(name + ".bat", os.X_OK):
        return os.path.abspath(name + ".bat")

    # go through PATH to find $name.exe or $name.bat
    for p in os.environ['PATH'].split(os.pathsep):
        p = p.strip('"')  # Sometimes paths are surrounded by ""

        if os.access(os.path.join(p, name + '.exe'), os.X_OK):
            return os.path.join(p, name + '.exe')
        if os.access(os.path.join(p, name + '.bat'), os.X_OK):
            return os.path.join(p, name + '.bat')

    raise IOError('Could not find ' + name + ' in PATH')
