#include "postgres.h"
#include "fmgr.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

Datum pg_strcmp(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1 (pg_strcmp);
Datum
pg_strcmp(PG_FUNCTION_ARGS)
{
    char       *a1p,
               *a2p;
    int         len1,
                len2,
				len;

    if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
      PG_RETURN_NULL();
    }

    Datum       arg1 = PG_GETARG_DATUM(0);
    Datum       arg2 = PG_GETARG_DATUM(1);

    a1p = VARDATA_ANY(arg1);
    a2p = VARDATA_ANY(arg2);

    len1 = VARSIZE_ANY_EXHDR(arg1);
    len2 = VARSIZE_ANY_EXHDR(arg2);
	len = len1 < len2 ? len1 : len2;

    PG_RETURN_BOOL( strncmp(a1p, a2p, len) == 0 );
}
