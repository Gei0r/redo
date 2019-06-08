"""Code for detecting and aborting on cyclic dependency loops."""
import os, helpers


class CyclicDependencyError(Exception):
    pass


def _get(env):
    """Get the list of held cycle items."""
    return env.get('REDO_CYCLES', '').split(':')


def add(fid, env=None):
    """Add a lock to the list of held cycle items."""
    if not env:
        env = os.environ
    items = set(_get(env))
    items.add(str(fid))
    env['REDO_CYCLES'] = ':'.join(list(items))
    helpers.mylog("add " + str(fid) + " to cycles")


def check(fid, env=None):
    if not env:
        env = os.environ
    if str(fid) in _get(env):
        # Lock already held by parent: cyclic dependency
        helpers.mylog("!! " + str(fid) + " already in " + os.environ.get('REDO_CYCLES', ''))
        raise CyclicDependencyError()
