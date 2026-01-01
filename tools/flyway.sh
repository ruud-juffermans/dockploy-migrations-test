#!/bin/sh
set -eu

# Usage:
#   ./tools/flyway.sh migrate
#   ./tools/flyway.sh info
#   ./tools/flyway.sh validate
#   ./tools/flyway.sh baseline
#   ./tools/flyway.sh repair

: "${FLYWAY_URL:?Missing FLYWAY_URL}"
: "${FLYWAY_USER:?Missing FLYWAY_USER}"
: "${FLYWAY_PASSWORD:?Missing FLYWAY_PASSWORD}"

CMD="${1:-}"
if [ -z "${CMD}" ]; then
  echo "Usage: $0 <migrate|info|validate|baseline|repair|clean>"
  exit 1
fi

SQL_DIR="/flyway/sql"
if [ ! -d "${SQL_DIR}" ]; then
  echo "Expected migrations at: ${SQL_DIR}"
  exit 1
fi

# Defaults (override via env)
FLYWAY_SCHEMAS="${FLYWAY_SCHEMAS:-public}"
FLYWAY_LOCATIONS="${FLYWAY_LOCATIONS:-filesystem:/flyway/sql}"
FLYWAY_CONNECT_RETRIES="${FLYWAY_CONNECT_RETRIES:-30}"
FLYWAY_VALIDATE_ON_MIGRATE="${FLYWAY_VALIDATE_ON_MIGRATE:-true}"

# Run flyway directly (no docker)
exec flyway \
  "-url=${FLYWAY_URL}" \
  "-user=${FLYWAY_USER}" \
  "-password=${FLYWAY_PASSWORD}" \
  "-schemas=${FLYWAY_SCHEMAS}" \
  "-locations=${FLYWAY_LOCATIONS}" \
  "-connectRetries=${FLYWAY_CONNECT_RETRIES}" \
  "-validateOnMigrate=${FLYWAY_VALIDATE_ON_MIGRATE}" \
  "${CMD}"
