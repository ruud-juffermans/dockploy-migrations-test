CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_messages_created_at
ON messages (created_at DESC);