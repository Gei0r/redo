"""Code for detecting and aborting on cyclic dependency loops."""
import os, helpers


class CyclicDependencyError(Exception):
    pass


def _get():
    """Get the list of held cycle items."""
    return os.environ.get('REDO_CYCLES', '').split(':')


def add(fid):
    """Add a lock to the list of held cycle items."""
    items = set(_get())
    items.add(str(fid))
    os.environ['REDO_CYCLES'] = ':'.join(list(items))
    helpers.mylog("add " + str(fid) + " to cycles")


def check(fid):
    cy = _get()
    helpers.mylog("check if " + str(fid) + " is in " + ", ".join(cy))
    if str(fid) in cy:
        # Lock already held by parent: cyclic dependency
        helpers.mylog("!! " + str(fid) + " already in " + os.environ.get('REDO_CYCLES', ''))
        raise CyclicDependencyError()
