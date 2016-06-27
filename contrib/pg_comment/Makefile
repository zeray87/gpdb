MODULES = pg_comment
#MODULE_big = pg_comment

EXTENSION = pg_comment
DATA = pg_comment--1.0.sql

DOCS = README.comment
OBJS = pg_comment.o

PGFILEDESC = "pg_comment - functions and operators for user defined comment type"

PGXS := $(shell pg_config --pgxs)
include $(PGXS)
