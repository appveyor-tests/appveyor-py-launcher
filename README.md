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

The `py.exe` launcher pre-installed on AppVeyor came from
Python 3.4.4. I was able to export the executable as an [artifact][4] and
use it with `PYLAUNCH_DEBUG` actually set. The reason it cannot find
the versions of Python is in [`locate_pythons_for_key`][3]:

```c
status = RegEnumKeyW(core_root, i, ip->version, MAX_VERSION_SIZE);
if (status != ERROR_SUCCESS) {
    if (status != ERROR_NO_MORE_ITEMS) {
        /* unexpected error */
        winerror(status, message, MSGSIZE);
        debug(L"Can't enumerate registry key for version %s: %s\n",
              ip->version, message);
    }
    break;
}
```

and the error indicates what is happening.

```
Can't enumerate registry key for version 3.5: More data is available.
```

This means that when trying to read the next key from `core_root`
into `ip->version`, it fails with a `message` of `"More data is available."`.
The fact that `ip->version` is `3.5` in the error message reflects the
value **just before** reading in the next key failed.

The `"More data is available."` failure occurs because the next key is
actually `3.5-32\0` (null-terminated), but `MAX_VERSION_SIZE`
[is `4`][6]. This is addressed [in 3.6.3][5] by allowing for to `8`
characters.

I have reported this ([1][1] and [2][2]) on the AppVeyor discussion
forums, though I'm not sure if this is the correct place.

[1]: https://docs.python.org/3/using/windows.html#diagnostics
[2]: https://docs.python.org/3/using/windows.html#installing-without-ui
[3]: https://github.com/python/cpython/blob/v3.4.4/PC/launcher.c#L215-L216
[4]: https://ci.appveyor.com/project/jonparrott/nox/build/1.0.298.master/job/bf75a49xokfko86v/artifacts
[5]: https://github.com/python/cpython/blob/v3.6.3/PC/launcher.c#L166
[6]: https://github.com/python/cpython/blob/v3.4.4/PC/launcher.c#L142
[7]: http://help.appveyor.com/discussions/problems/3626-python-windows-launcher-returns-code-103-when-specifying-35-32-bit
[8]: http://help.appveyor.com/discussions/problems/3891-py-35-32-hellopy-fails-with-error-code-103
