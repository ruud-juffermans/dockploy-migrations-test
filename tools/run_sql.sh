#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./tools/run_sql.sh ops/delete_old_messages.sql
#   ./tools/run_sql.sh ops/recent_messages.sql
#   ./tools/run_sql.sh ops/reindex_messages_concurrently.sql
#
# Requires env vars:
#   PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SQL_PATH="${1:-}"
if [[ -z "${SQL_PATH}" ]]; then
  echo "Usage: $0 <path-to-sql-file>"
  exit 1
fi

FULL_PATH="${ROOT_DIR}/${SQL_PATH}"
if [[ ! -f "${FULL_PATH}" ]]; then
  echo "SQL file not found: ${FULL_PATH}"
  exit 1
fi

: "${PGHOST:?Missing PGHOST}"
: "${PGPORT:?Missing PGPORT}"
: "${PGDATABASE:?Missing PGDATABASE}"
: "${PGUSER:?Missing PGUSER}"
: "${PGPASSWORD:?Missing PGPASSWORD}"

export PGPASSWORD

PSQL_BASE=(psql
  -h "${PGHOST}"
  -p "${PGPORT}"
  -U "${PGUSER}"
  -d "${PGDATABASE}"
  -X
)

echo "Running SQL: ${SQL_PATH}"
echo "Target DB:  ${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}"

"${PSQL_BASE[@]}" -f "${FULL_PATH}"


echo "Done."
