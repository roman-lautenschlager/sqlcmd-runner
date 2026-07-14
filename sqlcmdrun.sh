#!/usr/bin/env bash

# test sqlcmd command
if ! command -v sqlcmd &>/dev/null; then
  printf "%s%03d\t%s\n" "E" "$LINENO" "sqlcmd is NOT installed or not in \$PATH" >&2;
  exit 1;
fi

# resolve path
sql_path="";
if [[ $# -gt 0 ]]; then
  # read full path
  sql_path="${1%/}";
  if command -v realpath &>/dev/null; then
    sql_path=$(realpath "${1%/}")
  else
    sql_path=$(readlink -f "${1%/}")
  fi
  # path exist
  if ! [[ -d "${sql_path}" || -f "${sql_path}" ]]; then
    printf "%s%03d\t%s\n" "E" "$LINENO" "${sql_path} - path not found" >&2;
    exit 1
  fi
else
  printf "%s%03d\t%s\n" "E" "$LINENO" "provide path" >&2;
  exit 1
fi

# find files
SQL_FILE="";
if [[ -f "${sql_path}" ]]; then
  SQL_FILE=$( printf ':r %s\nGO' "${sql_path}" );
fi
if [[ -d "${sql_path}" ]]; then
  while read -r -d $'\0' SQLFILE; do
    if [[ -f "${SQLFILE}" ]]; then
      SQL_FILE=$( printf '%s\n:r %s\nGO' "${SQL_FILE}" "${SQLFILE}" );
    fi;
  done < <(find "${sql_path}" -type f -not -path '*/.*' -iname '*.sql' -print0 | sort --ignore-case --version-sort --zero-terminated);
fi

# run all
sqlcmd -b <<EOF
-- Stop execution and exit with a non-zero code if a SQL error occurs.
:on error exit

-- Roll back the entire transaction on any run-time error.
SET XACT_ABORT ON;

-- Suppress the "n rows affected" messages.
-- SET NOCOUNT ON;
GO

${SQL_FILE}
EOF
