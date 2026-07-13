#!/usr/bin/env pwsh

Param(
    [Parameter(Mandatory, Position = 0)]
    [string] $Path
)

# test sqlcmd command
if (-not (Get-Command sqlcmd -ErrorAction SilentlyContinue)) {
    Write-Error "sqlcmd - NOT found"
    exit 1
}

# resolve path
$SQL_PATH = $Path
try {
    $SQL_PATH = (Resolve-Path $Path -ErrorAction Stop).Path
} catch {
    Write-Error "$Path - path NOT found"
    exit 1
}

# find files
$SQL_FILE = ""
if (Test-Path $SQL_PATH -PathType Leaf) {
    $SQL_FILE = ":r `"$SQL_PATH`"`nGO"
}
if (Test-Path $SQL_PATH -PathType Container) {
    Get-ChildItem -Path $SQL_PATH -Recurse -File |
        Where-Object { $_.Attributes -notmatch 'Hidden' -and $_.Extension -imatch '\.(sql)$' } |
        Sort-Object { [regex]::Replace($_.FullName, '\d+', { $args[0].Value.PadLeft(20) }) } | # FullName |
        ForEach-Object { $SQL_FILE += "`n:r `"$($_.FullName)`"`nGO" }
}

# run all
@"
-- Stop execution and exit with a non-zero code if a SQL error occurs.
:on error exit

-- Roll back the entire transaction on any run-time error.
SET XACT_ABORT ON;

-- Suppress the "n rows affected" messages.
-- SET NOCOUNT ON;
GO

$SQL_FILE
"@ | sqlcmd -b

exit $LASTEXITCODE
