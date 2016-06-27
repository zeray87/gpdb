DROP TABLE IF EXISTS comment_tbl;
CREATE TABLE comment_tbl(
	    id		varchar,
		comment	Comment
);
--DISTRIBUTED BY(id);

INSERT INTO comment_tbl VALUES ('a', 'a');
INSERT INTO comment_tbl VALUES ('b', 'b');
INSERT INTO comment_tbl VALUES ('c', 'c');
INSERT INTO comment_tbl VALUES ('d', 'd');
INSERT INTO comment_tbl VALUES ('e', 'e');
INSERT INTO comment_tbl VALUES ('f', 'f');
INSERT INTO comment_tbl VALUES ('g', 'g');
INSERT INTO comment_tbl VALUES ('h', 'h');
INSERT INTO comment_tbl VALUES ('i', 'i');

SELECT id, comment from comment_tbl limit 7500;

DROP TABLE IF EXISTS comment_tbl_out;
CREATE TABLE comment_tbl_out(
	id		varchar,
	comment	Comment
);


INSERT INTO comment_tbl_out VALUES('1*a', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='a'), 1 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('10*b', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='b'), 10 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('100*c', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='c'), 100 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('1000*d', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='d'), 1000 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('10000*e', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='e'), 10000 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('100000*f', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='f'), 100000 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('1000000*g', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='g'), 1000000 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('10000000*h', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='h'), 10000000 ));
select id from comment_tbl_out order by id asc limit 1;
INSERT INTO comment_tbl_out VALUES('100000000*i', fillCommentWithLen((SELECT comment FROM comment_tbl WHERE id='i'), 100000000 ));
select id from comment_tbl_out order by id asc limit 1;

select id, length(comment::text) from comment_tbl_out order by id desc;
--SELECT id, comment FROM comment_tbl_out limit 7500;
