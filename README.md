# AppVeyor `py.exe` Launcher

This is a simple showcase of the broken-ness of `py.exe` on AppVeyor.

There are two primary complaints:

- The [`PYLAUNCH_DEBUG`][1] environment variable doesn't work
- Three versions of the official `python.org` Python versions are
  not detected by `py.exe` (32-bit Python 3.5 and both 32- and
  64-bit versions of Python 3.6)

I've tried a few things, like force re-installing `py.exe` via
the [`Include_launcher=1`][2] argument to the `python-X.Y.Z.exe`
installers.

[1]: https://docs.python.org/3/using/windows.html#diagnostics
[2]: https://docs.python.org/3/using/windows.html#installing-without-ui
