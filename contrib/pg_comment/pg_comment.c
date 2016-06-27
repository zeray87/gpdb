#include "postgres.h"
#include "fmgr.h"		//PG_NARG()
#include "libpq/pqformat.h"
#include "utils/builtins.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif


Datum comment_in (PG_FUNCTION_ARGS);
Datum comment_out (PG_FUNCTION_ARGS);
Datum comment_recv (PG_FUNCTION_ARGS);
Datum comment_send (PG_FUNCTION_ARGS);

Datum fillCommentWithLen (PG_FUNCTION_ARGS);


typedef struct varlena Comment;
#define PG_RETURN_COMMENT_P(x)    PG_RETURN_POINTER(x)


PG_FUNCTION_INFO_V1(comment_in);
Datum
comment_in(PG_FUNCTION_ARGS)
{
    char       *inputComment = PG_GETARG_CSTRING(0);

	PG_RETURN_TEXT_P(cstring_to_text(inputComment));
}


PG_FUNCTION_INFO_V1(comment_out);
Datum
comment_out(PG_FUNCTION_ARGS)
{
    Datum comment = PG_GETARG_DATUM(0);

	PG_RETURN_CSTRING(TextDatumGetCString(comment));
}

PG_FUNCTION_INFO_V1(comment_recv);
Datum
comment_recv(PG_FUNCTION_ARGS)
{
    StringInfo	buf = (StringInfo) PG_GETARG_POINTER(0);
    Comment	   *result;
    char       *str;
    int         nbytes;

    str = pq_getmsgtext(buf, buf->len - buf->cursor, &nbytes);

    result = cstring_to_text_with_len(str, nbytes);
    pfree(str);
	PG_RETURN_COMMENT_P(result);
}

PG_FUNCTION_INFO_V1(comment_send);
Datum
comment_send(PG_FUNCTION_ARGS)
{
    Comment    *comment = (Comment *) PG_GETARG_POINTER(0);
    StringInfoData buf;

    pq_begintypsend(&buf);
	pq_sendtext(&buf, VARDATA_ANY(comment), VARSIZE_ANY_EXHDR(comment));
    PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

PG_FUNCTION_INFO_V1(fillCommentWithLen);
Datum
fillCommentWithLen(PG_FUNCTION_ARGS)
{
	if ( PG_NARGS() < 2 || PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
		elog(WARNING, "fillCommentWithLen has incorrect args");
		PG_RETURN_NULL();
	}

	Datum       d = PG_GETARG_DATUM(0);
	text       *comment = DatumGetTextPP(d);
    int			oldCommentLen = VARSIZE_ANY_EXHDR(comment);
    char	   *oldCommentStr = VARDATA_ANY(comment);

	int         newCommentLen = PG_GETARG_INT32(1);
	Comment    *newComment = (Comment *) palloc(newCommentLen + VARHDRSZ);

	int			fillTimes;
	int			fileTail;
	if (oldCommentLen == 0) {
		fillTimes = 0;
		fileTail = newCommentLen;
	}
	else {
		fillTimes = newCommentLen / oldCommentLen;
		fileTail = newCommentLen % oldCommentLen;
	}

	int			fillCursor = 0;
	int			i = 0;
	for (i = 0; i < fillTimes; i++) {
		memcpy(VARDATA(newComment) + fillCursor, oldCommentStr, oldCommentLen);
		fillCursor += oldCommentLen;
	}
	memcpy(VARDATA(newComment) + fillCursor, oldCommentStr, fileTail);

	SET_VARSIZE(newComment, newCommentLen + VARHDRSZ);
	PG_RETURN_COMMENT_P(newComment);
}
