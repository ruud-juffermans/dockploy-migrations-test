# Development seed data

Purpose:
- Populate the database with realistic sample data for local development.
- Used for manual testing, UI development, and API sanity checks.

Rules:
- NEVER run in production.
- Must be idempotent (safe to re-run).
- Should not assume empty tables.
- Should not rely on fixed primary keys.

How to run:

Using psql directly:
  psql -h localhost -U appuser -d appdb -f seed_messages.sql

Using the repo helper script:
  ./tools/scripts/run_sql.sh seeds/dev/seed_messages.sql