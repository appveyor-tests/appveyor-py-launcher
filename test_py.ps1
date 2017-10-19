$ErrorActionPreference = "Stop"

$result = (cmd /c info.py)
$result
if ($result[0] -ne '>>> import sys') { throw "Unexpected result from launching info.py" }

$py_versions = @(
    "2.6"
    "2.6-32"
    "2.7"
    "2.7-32"
    "3.3"
    "3.3-32"
    "3.4"
    "3.4-32"
    "3.5"
    "3.5-32"
    "3.6"
    "3.6-32"
)

foreach($py_version in $py_versions) {
    Write-Host "Launch py.exe for $py_version" -ForegroundColor Cyan
    cmd /c py.exe -$py_version .\info.py
}
