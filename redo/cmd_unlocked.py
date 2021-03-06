"""redo-unlocked: internal tool for building dependencies."""
import sys, os
from . import env, logs, state


def main():
    if len(sys.argv[1:]) < 2:
        sys.stderr.write('%s: at least 2 arguments expected.\n' % sys.argv[0])
        sys.exit(1)

    env.inherit()
    logs.setup(
        tty=sys.stderr, parent_logs=env.v.LOG,
        pretty=env.v.PRETTY, color=env.v.COLOR)

    target = sys.argv[1]
    deps = sys.argv[2:]

    for d in deps:
        assert d != target

    me = state.File(name=target)

    # Build the known dependencies of our primary target.  This *does* require
    # grabbing locks.
    os.environ['REDO_NO_OOB'] = '1'
    argv = ['redo-ifchange'] + deps
    if os.name == 'nt':
        # no spawnvp() on windows, we need to search PATH ourselves.
        from .helpers import which_win
        argv[0] = which_win(argv[0])
        rv = os.spawnv(os.P_WAIT, argv[0], argv)
    else:
        rv = os.spawnvp(os.P_WAIT, argv[0], argv)

    if rv:
        sys.exit(rv)

    # We know our caller already owns the lock on target, so we don't have to
    # acquire another one; tell redo-ifchange about that.  Also, REDO_NO_OOB
    # persists from up above, because we don't want to do OOB now either.
    # (Actually it's most important for the primary target, since it's the one
    # who initiated the OOB in the first place.)
    os.environ['REDO_UNLOCKED'] = '1'
    argv = ['redo-ifchange', target]
    if os.name == 'nt':
        # no spawnvp() on windows, we need to search PATH ourselves.
        from .helpers import which_win
        argv[0] = which_win(argv[0])
        rv = os.spawnv(os.P_WAIT, argv[0], argv)
    else:
        rv = os.spawnvp(os.P_WAIT, argv[0], argv)

    if rv:
        sys.exit(rv)


if __name__ == '__main__':
    main()
