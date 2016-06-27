CREATE FUNCTION comment_in(cstring)
    RETURNS Comment
    AS 'pg_comment'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION comment_out(Comment)
    RETURNS cstring
    AS 'pg_comment'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION comment_recv(internal)
   RETURNS Comment
   AS 'pg_comment'
   LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION comment_send(Comment)
   RETURNS bytea
   AS 'pg_comment'
   LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION fillCommentWithLen(Comment, integer)
   RETURNS Comment
   AS 'pg_comment', 'fillCommentWithLen'
   LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE Comment (
   internallength = VARIABLE, 
   input = comment_in,
   output = comment_out,
   receive = comment_recv,
   send = comment_send,
   storage = EXTENDED,
   alignment = double
);
