SELECT
  id,
  content,
  created_at
FROM messages
ORDER BY created_at DESC
LIMIT 10;