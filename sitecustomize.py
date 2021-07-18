from pkg_resources import EntryPoint

AUTO_IMPORTS = [
        ("debug", "devtools.debug:debug", "pprint:pprint"),
        ("bpoint", "pdbr:set_trace", "pdb:set_trace"),
]


for name, path, fallback in AUTO_IMPORTS:
    try:
        __builtins__[name] = EntryPoint.parse("__name = {}".format(path)).resolve()
    except (ImportError, ModuleNotFoundError):
        __builtins__[name] = EntryPoint.parse("__name = {}".format(fallback)).resolve()


try:
    from _sitebuiltins import Quitter
    if isinstance(exit, Quitter):
        class MyQuitter(Quitter):
            def __repr__(self):
                self(0)

        __builtins__["exit"] = MyQuitter(exit.name, exit.eof)
except (ImportError, NameError):
    pass
