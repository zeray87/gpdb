CREATE OR REPLACE FUNCTION strcmp(in text, in text, out boolean)
AS 'pg_strcmp', 'pg_strcmp'
LANGUAGE C;
