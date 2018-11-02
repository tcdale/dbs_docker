ALTER SYSTEM SET shared_preload_libraries='pg_stat_statements';
ALTER SYSTEM SET max_connections=1000;
ALTER SYSTEM SET track_activity_query_size=1000;
ALTER SYSTEM SET shared_buffers='1024MB';
