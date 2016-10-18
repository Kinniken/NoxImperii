/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file ntime.c
 *
 * @brief Handles the Naev time.
 *
 * 1 SCU =  5e3 STP = 50e6 STU
 * 1 STP = 10e3 STU
 * 1 STU = 1 second
 *
 * Generally displayed as:
 *  <SCU>:<STP>.<STU> UST
 * The number of STU digits can be variable, for example:
 *
 *  630:3726.1 UST
 *  630:3726.12 UST
 *  630:3726.124 UST
 *  630:3726.1248 UST
 *  630:3726.12489 UST
 *
 * Are all valid.
 *
 * Acronyms:
 *    - UST : Universal Synchronized Time
 *    - STU : Smallest named time unit. Equal to the Earth second.
 *    - STP : Most commonly used time unit. STPs are the new hours. 1 STP = 10,000 STU (about 2.8 Earth hours).
 *    - SCU : Used for long-term time periods. 1 SCU = 5000 STP (about 579 Earth days).
 */


#include "ntime.h"

#include "naev.h"

#include <stdio.h>
#include "nstring.h"
#include <stdlib.h>

#include "hook.h"
#include "economy.h"

#include "crew.h"


static char* ntime_monthName(int month);


/**
 * @brief Used for storing time increments to not trigger hooks during Lua
 *        calls and such.
 */
typedef struct NTimeUpdate_s {
   struct NTimeUpdate_s *next; /**< Next in the linked list. */
   ntime_t inc; /**< Time increment associated. */
} NTimeUpdate_t;
static NTimeUpdate_t *ntime_inclist = NULL; /**< Time increment list. */


static ntime_t naev_time = 0; /**< Contains the current time in mSTU. */
static double naev_remainder = 0.; /**< Remainder when updating, to try to keep in perfect sync. */
static int ntime_enable = 1; /** Allow updates? */


void ntime_getBreakdown( ntime_t t, int *years, int *months, int *days, int *hours, int *minutes, int *seconds )
{
	long tmonths,tdays,thours,tminutes,tseconds;

	tmonths = (t / NT_MONTH_DIV);
	tdays = (t / NT_DAY_DIV);
	thours = (t / NT_HOUR_DIV);
	tminutes = (t / NT_MIN_DIV);
	tseconds = (t / NT_SEC_DIV);

	*years = (t / NT_YEAR_DIV);
	*months = tmonths - (*years)*NT_MONTH_IN_YEAR;
	*days = tdays - (tmonths)*NT_DAY_IN_MONTH;
	*hours = thours - (tdays)*NT_HOUR_IN_DAY;
	*minutes = tminutes - (thours)*NT_MIN_IN_HOUR;
	*seconds = tseconds - (tminutes)*NT_SEC_IN_MIN;
}

/**
 * @brief Updates the time based on realtime.
 */
void ntime_update( double dt )
{
   double dtt, tu;
   ntime_t inc;

   /* Only if we need to update. */
   if (!ntime_enable)
      return;

   /* Calculate the effective time. */
   dtt = naev_remainder + dt*NT_GAME_TO_REAL_RATIO*NT_SEC_DIV;

   /* Time to update. */
   tu             = floor( dtt );
   inc            = (ntime_t) tu;
   naev_remainder = dtt - tu; /* Leave remainder. */

   /* Increment. */
   naev_time     += inc;
   hooks_updateDate( inc );
}


/**
 * @brief Gets the current time.
 *
 *    @return The current time in mSTU.
 */
ntime_t ntime_get (void)
{
   return naev_time;
}


/**
 * @brief Converts the time to seconds.
 *    @param t Time to convert.
 *    @return Time in seconds.
 */
long ntime_convertTimeToSeconds( ntime_t t )
{
   return ((long)t / NT_SEC_DIV);
}

ntime_t ntime_getTimeFromSeconds( long s )
{
   return ((ntime_t)s * NT_SEC_DIV);
}


/**
 * @brief Gets the remainder.
 */
double ntime_getRemainder( ntime_t t )
{
   return (double)(t % NT_SEC_DIV);
}


/**
 * @brief Gets the time in a pretty human readable format.
 *
 *    @param t Time to print, if 0 it'll use the current time.
 *    @param d  1 for date only, 0 for date and time
 *    @return The time in a human readable format (must free).
 */
char* ntime_pretty( ntime_t t, int dateOnly )
{
   char str[64];
   ntime_prettyBuf( str, sizeof(str), t, dateOnly );
   return strdup(str);
}


/**
 * @brief Gets the time in a pretty human readable format filling a preset buffer.
 *
 *    @param[out] str Buffer to use.
 *    @param max Maximum length of the buffer (recommended 64).
 *    @param t Time to print, if 0 it'll use the current time.
 *    @param d 1 for date only, 0 for date and time
 *    @return The time in a human readable format (must free).
 */
void ntime_prettyBuf( char *str, int max, ntime_t t, int dateOnly )
{
   ntime_t nt;
   int sec,min,hour,day,month,year;

   if (t==0)
      nt = naev_time;
   else
      nt = t;

   ntime_getBreakdown(nt, &year,&month,&day,&hour,&min,&sec);

   if (nt<NT_DAY_DIV) {//duration below a day
	   nsnprintf( str, max, "%dh %dm", hour, min );
   } else if (nt<NT_MONTH_DIV) {//duration below a month
   	   nsnprintf( str, max, "%dd  %dh %dm", day, hour, min );
   } else if (nt<NT_YEAR_DIV) {//duration below a year
	   nsnprintf( str, max, "%dm %dd  %dh %dm", month, day, hour, min );
   } else {//Date
	   if (dateOnly) {
		   nsnprintf( str, max, "%s %d, %d CE", ntime_monthName(month+1), day+1, year );
	   } else {
		   nsnprintf( str, max, "%s %d, %d CE  %02d:%02d", ntime_monthName(month+1), day+1, year, hour, min );
	   }
   }
}

static char* ntime_monthName(int month) {
	if (month==1) {
		return "January";
	} else if (month==2) {
		return "February";
	} else if (month==3) {
		return "March";
	} else if (month==4) {
		return "April";
	} else if (month==5) {
		return "May";
	} else if (month==6) {
		return "June";
	} else if (month==7) {
		return "July";
	} else if (month==8) {
		return "August";
	} else if (month==9) {
		return "September";
	} else if (month==10) {
		return "October";
	} else if (month==11) {
		return "November";
	} else if (month==12) {
		return "December";
	} else {
		ERR("Was asked for month %i.",month);
		return "MONTHERROR";
	}
}


/**
 * @brief Sets the time absolutely, does NOT generate an event, used at init.
 *
 *    @param t Absolute time to set to in STU.
 */
void ntime_set( ntime_t t )
{
   naev_time      = t;
   naev_remainder = 0.;
}


/**
 * @brief Loads time including remainder.
 */
void ntime_setR( long timeInSec, double rem )
{
   naev_time   = (ntime_t)(floor(timeInSec));
   naev_time  += floor(rem);
   naev_remainder = fmod( rem, 1. );
}


/**
 * @brief Sets the time relatively.
 *
 *    @param t Time modifier in STU.
 */
void ntime_inc( ntime_t t )
{
   naev_time += t;

   /* Run hooks. */
   if (t > 0) {
      hooks_updateDate( t );
   }
}

ntime_t ntime_create( int years, int months, int days, int hours, int minutes, int seconds )
{
   ntime_t sec,min,hour,day,month,year;

   sec=seconds;
   min=minutes;
   hour=hours;
   day=days;
   month=months;
   year=years;


   return sec*NT_SEC_DIV+min*NT_MIN_DIV+hour*NT_HOUR_DIV+day*NT_DAY_DIV+month*NT_MONTH_DIV+year*NT_YEAR_DIV;
}


/**
 * @brief Allows the time to update when the game is updating.
 *
 *    @param enable Whether or not to enable time updating.
 */
void ntime_allowUpdate( int enable )
{
   ntime_enable = enable;
}


/**
 * @brief Sets the time relatively.
 *
 * This does NOT call hooks and such, they must be run with ntime_refresh
 *  manually later.
 *
 *    @param t Time modifier in STU.
 */
void ntime_incLagged( ntime_t t )
{
   NTimeUpdate_t *ntu, *iter;

   /* Create the time increment. */
   ntu = malloc(sizeof(NTimeUpdate_t));
   ntu->next = NULL;
   ntu->inc = t;

   /* Only member. */
   if (ntime_inclist == NULL)
      ntime_inclist = ntu;

   else {
      /* Find end of list. */
      for (iter = ntime_inclist; iter->next != NULL; iter = iter->next);
      /* Append to end. */
      iter->next = ntu;
   }
}


/**
 * @brief Checks to see if ntime has any hooks pending to run.
 */
void ntime_refresh (void)
{
   NTimeUpdate_t *ntu;

   /* We have to run all the increments one by one to ensure all hooks get
    * run and that no collisions occur. */
   while (ntime_inclist != NULL) {
      ntu = ntime_inclist;

      /* Run hook stuff and actually update time. */
      naev_time += ntu->inc;

      /* Remove the increment. */
      ntime_inclist = ntu->next;

      /* Free the increment. */
      free(ntu);
   }
}


ntime_t ntime_parseNode(xmlNodePtr node, const char * debugLabel) {
	xmlNodePtr cur;
	int years,months,days, hours,minutes,seconds;

	years=months=days=hours=minutes=seconds=0;

	cur = node->children;
	 do {
		xml_onlyNodes(cur);

		xmlr_int( cur, "years", years );
		xmlr_int( cur, "months", months );
		xmlr_int( cur, "days", days );
		xmlr_int( cur, "hours", hours );
		xmlr_int( cur, "minutes", minutes );
		xmlr_int( cur, "seconds", seconds );
		WARN("'%s' has unknown date node '%s'.", debugLabel, cur->name);
	 } while (xml_nextNode(cur));

	 return ntime_create(years,months,days,hours,minutes,seconds);
}

int ntime_saveNode(xmlTextWriterPtr writer, ntime_t time) {
	int years,months,days, hours,minutes,seconds;

	ntime_getBreakdown(time,&years,&months,&days,&hours,&minutes,&seconds);

	xmlw_elem(writer,"years","%d", years);
	xmlw_elem(writer,"months","%d", months);
	xmlw_elem(writer,"days","%d", days);
	xmlw_elem(writer,"hours","%d", hours);
	xmlw_elem(writer,"minutes","%d", minutes);
	xmlw_elem(writer,"seconds","%d", seconds);

	return 0;
}

