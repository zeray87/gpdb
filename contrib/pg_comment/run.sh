make clean
make
make install
dropdb test
createdb test
psql test -f pg_comment.sql
psql test -f test.sql
