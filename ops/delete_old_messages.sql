DELETE FROM messages
WHERE created_at < now() - interval '90 days';