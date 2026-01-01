#!/bin/sh
set -e

flyway migrate

if [ "${FLYWAY_STAY_RUNNING:-false}" = "true" ]; then
  echo "Flyway finished. Staying alive."
  tail -f /dev/null
fi
