-- Seed data for local development
-- Safe to re-run: uses deterministic content and avoids duplicates

INSERT INTO messages (content, created_at)
SELECT v.content, v.created_at
FROM (
  VALUES
    ('Hello world',                    now() - interval '3 days'),
    ('First local dev message',        now() - interval '2 days'),
    ('Testing Postgres integration',   now() - interval '36 hours'),
    ('Flyway migrations are working',  now() - interval '24 hours'),
    ('Ops scripts > ad-hoc SQL',       now() - interval '12 hours'),
    ('Local seed data example',        now() - interval '6 hours'),
    ('Latest message in the system',   now())
) AS v(content, created_at)
WHERE NOT EXISTS (
  SELECT 1
  FROM messages m
  WHERE m.content = v.content
);