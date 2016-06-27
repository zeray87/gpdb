DROP TABLE IF EXISTS text_tbl;
CREATE TABLE text_tbl(
	    id		varchar,
		str		text
);
--DISTRIBUTED BY(id);

INSERT INTO text_tbl VALUES ('a', 'a');
INSERT INTO text_tbl VALUES ('b', 'b');
INSERT INTO text_tbl VALUES ('c', 'c');
INSERT INTO text_tbl VALUES ('d', 'd');
INSERT INTO text_tbl VALUES ('e', 'e');
INSERT INTO text_tbl VALUES ('f', 'f');
INSERT INTO text_tbl VALUES ('g', 'g');
INSERT INTO text_tbl VALUES ('h', 'h');
INSERT INTO text_tbl VALUES ('i', 'i');

SELECT id, str from text_tbl limit 7500;

DROP TABLE IF EXISTS text_tbl_out;
CREATE TABLE text_tbl_out(
	id		varchar,
	str		text
);


INSERT INTO text_tbl_out VALUES('1000000*e', repeat((SELECT str FROM text_tbl WHERE id='e'), 1000000 ));

select id, length(str) from text_tbl_out order by id desc;
--SELECT id, comment FROM text_tbl_out limit 7500;
