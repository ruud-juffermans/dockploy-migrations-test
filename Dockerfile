FROM flyway/flyway:11.20.0

USER root

# Install psql client (Debian/Ubuntu base in this image)
RUN apt-get update \
  && apt-get install -y --no-install-recommends postgresql-client ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Flyway migrations
# (Adjust if your folder is flyway/sql instead of migrations)
COPY migrations /flyway/sql

# Interactive assets
COPY ops /repo/ops
COPY seeds /repo/seeds
COPY tools /repo/tools

# Flyway settings
COPY flyway.conf /flyway/conf/flyway.conf

# Entrypoint wrapper
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /repo
ENTRYPOINT ["/entrypoint.sh"]
