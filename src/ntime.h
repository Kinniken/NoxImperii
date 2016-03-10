/*
 * See Licensing and Copyright notice in naev.h
 */


#ifndef NTIME_H
#  define NTIME_H


#include <stdint.h>
#include "nxml.h"


#define NT_SEC_IN_MIN   (60)
#define NT_MIN_IN_HOUR   (60)
#define NT_HOUR_IN_DAY   (24)
#define NT_DAY_IN_MONTH   (30) //magic rational calendar!
#define NT_MONTH_IN_YEAR   (12)

#define NT_SEC_DIV   (1000)
#define NT_MIN_DIV   ((ntime_t)NT_SEC_IN_MIN*(ntime_t)NT_SEC_DIV)
#define NT_HOUR_DIV   ((ntime_t)NT_MIN_IN_HOUR*(ntime_t)NT_MIN_DIV)
#define NT_DAY_DIV   ((ntime_t)NT_HOUR_IN_DAY*(ntime_t)NT_HOUR_DIV)
#define NT_MONTH_DIV   ((ntime_t)NT_DAY_IN_MONTH*(ntime_t)NT_DAY_DIV)
#define NT_YEAR_DIV   ((ntime_t)NT_MONTH_IN_YEAR*(ntime_t)NT_MONTH_DIV)


typedef int64_t ntime_t;         /**< Core time type. */

/* update */
void ntime_update( double dt );

/* get */
ntime_t ntime_get (void);
ntime_t ntime_create( int years, int months, int days, int hours, int minutes, int seconds );
void ntime_getBreakdown( ntime_t t, int *years, int *months, int *days, int *hours, int *minutes, int *seconds );
long ntime_convertTimeToSeconds( ntime_t t );
ntime_t ntime_getTimeFromSeconds( long s );
double ntime_getRemainder( ntime_t t );
char* ntime_pretty( ntime_t t, int d );
void ntime_prettyBuf( char *str, int max, ntime_t t, int d );

/* set */
void ntime_set( ntime_t t );
void ntime_setR( long timeInSec, double rem );
void ntime_inc( ntime_t t );
void ntime_incLagged( ntime_t t );

/* misc */
void ntime_refresh (void);
void ntime_allowUpdate( int enable );

ntime_t ntime_parseNode(xmlNodePtr node, const char * debugLabel);
int ntime_saveNode(xmlTextWriterPtr writer, ntime_t time);


#endif /* NTIME_H */
