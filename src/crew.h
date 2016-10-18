/*
 * crew.h
 *
 *  Created on: 29 févr. 2016
 *      Author: cedricdj
 */

#ifndef CREW_H_
#define CREW_H_

#include <stdint.h>
#include "opengl.h"
#include "shipstats.h"
#include "economy.h"
#include "space.h"

#define CREW_GENDER_MALE 1
#define CREW_GENDER_FEMALE 2
#define CREW_GENDER_NEUTRAL 3

#define HCREW_STATUS_OK 1
#define HCREW_STATUS_WOUNDED 2


/* availability by location */
enum {
   CREW_AVAIL_NONE,       /**< Mission isn't available (only from missions). */
   CREW_AVAIL_BAR,        /**< Mission is available at bar. */
};

typedef struct CrewPosition_ {
   char* name; /**< name of the position */
} CrewPosition;

typedef struct Crew_ {
   char* name; /**< name of the crew ("Old Pilot", not real name). */
   char* position; /** position this belongs to **/
   char* description; /**< Description of the crew. */
   int level;
   char* nameGenerator; /**< reference of the name generator for this crew member **/
   int gender; /** 1=male, 2=female, 3=neutral **/

   /* Prices. */
   credits_t hiringPrice; /**< Hiring price of the crew member. */
   credits_t monthlySalary; /**< Salary of the crew member. */

   int loc; /* factions where available (if from bars) */
   int chance; /** chance on 100 of it appearing (if bar) */

   int* factions; /**< To certain factions. */
   int nfactions; /**< Number of factions in factions. */

   char* cond; /**< Condition that must be met (Lua). */

   char* portrait; /**< Crew graphic. */
   char* background; /**< Crew background. */

   int combatRatingNeeded;
   int factionNeeded;
   int factionRelationNeeded;

   //"Stolen" from the ship class
   char *desc_stats; /**< Ship statistics information. */
   ShipStatList *stats; /**< Ship statistics properties. */
   ShipStats stats_array; /**< Laid out stats for referencing purposes. */

} Crew;

typedef struct HiredCrew_ {
	const Crew* crew;
	char *generatedName;
	int active;
	int status;
} HiredCrew;

/*
 * Crew stuff.
 */
Crew* crew_get( const char* name );

/*
 * Crew positions stuff.
 */
CrewPosition* crewPosition_get( const char* name );
int crewPosition_load (void);

void crew_addToBar(const Planet* landPlanet);
int crew_hireCrewFromBar(const Crew *crew, const char *generatedName);

/**
 * Crew screen methods
 */
void crew_open( unsigned int wid );
void crew_update_active( unsigned int wid, char* str );
void crew_update_reserve( unsigned int wid, char* str );

HiredCrew* crew_getActiveCrewForPosition(const char* position);
void crew_generateCrewLists(unsigned int wid);

char* crew_getGenderPronoun(const Crew* crew);

void crew_checkForSalaryPayment(void);
void crew_setCrewPaymentTime( ntime_t timeVal );
ntime_t crew_getCrewPaymentTime( void );

#endif /* SRC_CREW_H_ */
