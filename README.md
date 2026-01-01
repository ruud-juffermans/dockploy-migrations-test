# Database Migrations & Operations

This repository contains everything related to **database schema management, migrations, and operational SQL**
for the application.

It is designed to be used **inside the Flyway container** (local development, CI, or deployment jobs).

---

## Contents

- **Flyway migrations** (`/migrations`)
- **Operational SQL scripts** (`/ops`)
- **Seed data** (`/seeds`)
- **Helper scripts** (`/tools`)
- **Flyway configuration** (`flyway.conf`)

---

## Folder Structure

```
.
├── migrations/          # Flyway versioned/repeatable migrations (V__ / R__)
├── ops/                 # Operational SQL (manual / ad-hoc / maintenance)
├── seeds/               # Seed data (manual or controlled execution)
├── tools/
│   ├── flyway.sh        # Wrapper for running Flyway commands (inside container)
│   └── run_sql.sh       # Execute a single SQL file via psql
├── flyway.conf          # Local Flyway configuration
└── README.md
```

---

## Environment Variables (Required)

These **must be set** before running any scripts.

### Database connection (psql)
```bash
PGHOST=db
PGPORT=5432
PGDATABASE=appdb
PGUSER=appuser
PGPASSWORD=apppass
```

### Flyway (if not fully defined in flyway.conf)
```bash
FLYWAY_URL=jdbc:postgresql://db:5432/appdb
FLYWAY_USER=appuser
FLYWAY_PASSWORD=apppass
```

---

## Optional Environment Variables

### Flyway
```bash
FLYWAY_SCHEMAS=public
FLYWAY_LOCATIONS=filesystem:/flyway/sql
FLYWAY_CONNECT_RETRIES=30
FLYWAY_VALIDATE_ON_MIGRATE=true
FLYWAY_STAY_RUNNING=true   # Keep container alive after migrate (local dev)
```

### psql execution
```bash
PSQL_ON_ERROR_STOP=1
```

---

## Flyway Usage

The `tools/flyway.sh` script runs **Flyway directly inside the container**.

### Usage

```bash
./tools/flyway.sh migrate
./tools/flyway.sh info
./tools/flyway.sh validate
./tools/flyway.sh baseline
./tools/flyway.sh repair
```

### Examples

```bash
./tools/flyway.sh info
./tools/flyway.sh validate
./tools/flyway.sh migrate
```

### What this does

- Uses migrations from `/flyway/sql`
- Applies them in order using Flyway
- Fails fast on validation or migration errors

---

## Running Operational SQL (psql)

Operational SQL scripts are **not managed by Flyway**.
They are run manually using `psql`.

Use `tools/run_sql.sh`.

### Usage

```bash
./tools/run_sql.sh ops/delete_old_messages.sql
./tools/run_sql.sh ops/recent_messages.sql
./tools/run_sql.sh ops/reindex_messages_concurrently.sql
```

### Example

```bash
./tools/run_sql.sh ops/delete_old_messages.sql
```

### What this does

- Executes exactly **one SQL file**
- Runs against the target database using `psql`
- Stops immediately on error
- Does **not** touch `flyway_schema_history`

---

## Rules & Conventions

### Flyway migrations (`/migrations`)
✔ Schema changes only  
✔ Deterministic and versioned  
✔ Safe for automated execution  

❌ No ad-hoc fixes  
❌ No environment-specific data  

---

### Operational SQL (`/ops`)
✔ Maintenance tasks  
✔ Cleanup jobs  
✔ Index rebuilds  
✔ One-off fixes  

❌ Never auto-run  
❌ Never versioned by Flyway  

---

### Seed data (`/seeds`)
✔ Development / demo data  
✔ Controlled execution  

❌ Never auto-run in production  

---

## Typical Workflows

### Local development

```bash
./tools/flyway.sh migrate
./tools/run_sql.sh seeds/dev_seed.sql
```

### Production deployment

```bash
./tools/flyway.sh validate
./tools/flyway.sh migrate
```

### Manual maintenance

```bash
./tools/run_sql.sh ops/reindex_messages_concurrently.sql
```

---

## Safety Notes

- **Never run `flyway clean` in production**
- Always review SQL in `ops/` before execution
- Prefer Flyway migrations for schema evolution
- Keep operational SQL idempotent where possible

---

## Summary

- **Flyway** → schema evolution
- **ops** → operational / maintenance SQL
- **seeds** → controlled data injection
- **tools** → execution helpers

This structure keeps database changes safe, auditable, and production-ready.
