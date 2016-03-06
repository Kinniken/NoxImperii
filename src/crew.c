/*
 * crew.c
 *
 *  Created on: 29 févr. 2016
 *      Author: cedricdj
 */

#include "crew.h"

#include "naev.h"

#include <stdio.h>
#include "nstring.h"
#include <stdint.h>

#ifdef HAVE_SUITESPARSE_CS_H
#include <suitesparse/cs.h>
#else
#include <cs.h>
#endif

#include "array.h"
#include "nxml.h"
#include "ndata.h"
#include "log.h"
#include "spfx.h"
#include "pilot.h"
#include "rng.h"
#include "space.h"
#include "ntime.h"
#include "npc.h"
#include "nlua.h"
#include "nluadef.h"
#include "land.h"
#include "toolkit.h"
#include "tk/toolkit_priv.h"
#include "opengl.h"
#include "player.h"
#include "pilot_outfit.h"
#include "rng.h"
#include "cond.h"
#include "dialogue.h"
#include "float.h"

#define XML_POSITION_ID      "Positions" /**< XML document identifier */
#define XML_POSITION_TAG     "position" /**< XML commodity identifier. */
#define XML_CREW_TAG     "crew" /**< XML commodity identifier. */
static const int MAX_FUNC_NAME = 128;
static const int MAX_BAR_DESC = 1024;
/* crew stack */
static Crew* crews_stack = NULL; /**< Contains all the crews. */
static int crews_nstack = 0; /**< Number of crews in the stack. */

/* crew stack */
static CrewPosition* crewPositions_stack = NULL; /**< Contains all the crew positions. */
static int crewPositions_nstack = 0; /**< Number of crew positions in the stack. */

static int crewPosition_parse( CrewPosition *temp, xmlNodePtr parent );
static int crew_parse( Crew *temp, xmlNodePtr parent, CrewPosition* position );
static int crew_location( const char* loc );
static char* crew_findName( char* nameGenerator );

static void display_crew(unsigned int wid, char* str);
static void crew_setCrewActive( unsigned int wid, char* str );
static void crew_setCrewReserve( unsigned int wid, char* str );
static char* crew_getLevelName(int level);
static int crew_gender( char* genderName );
static int crew_checkBarConditions(Crew* crew, const Planet* landPlanet);
static int crew_matchFaction( Crew* crew, int faction );

static lua_State *crew_name_lua = NULL; /** Crew name generators */

#define STATS_DESC_MAX 256 /**< Maximum length for statistics description. */

/**
 * @brief Loads all the crews and crew positions data.
 *
 *    @return 0 on success.
 */
int crewPosition_load (void)
{
	uint32_t bufsize;
	char *buf;
	xmlNodePtr node;
	xmlDocPtr doc;

	/* Load the file. */
	buf = ndata_read( CREW_DATA_PATH, &bufsize);
	if (buf == NULL)
		return -1;

	/* Handle the XML. */
	doc = xmlParseMemory( buf, bufsize );
	if (doc == NULL) {
		WARN("'%s' is not valid XML.", CREW_DATA_PATH);
		return -1;
	}

	node = doc->xmlChildrenNode; /* Positions node */
	if (strcmp((char*)node->name,XML_POSITION_ID)) {
		ERR("Malformed "CREW_DATA_PATH" file: missing root element '"XML_POSITION_ID"'");
		return -1;
	}

	node = node->xmlChildrenNode; /* first position node */
	if (node == NULL) {
		ERR("Malformed "CREW_DATA_PATH" file: does not contain elements");
		return -1;
	}

	do {
		xml_onlyNodes(node);
		if (xml_isNode(node, XML_POSITION_TAG)) {

			/* Make room for position. */
			crewPositions_stack = realloc(crewPositions_stack,
					sizeof(CrewPosition)*(++crewPositions_nstack));

			/* Load position. */
			crewPosition_parse(&crewPositions_stack[crewPositions_nstack-1], node);
		}
		else
			WARN("'"COMMODITY_DATA_PATH"' has unknown node '%s'.", node->name);
	} while (xml_nextNode(node));

	xmlFreeDoc(doc);
	free(buf);

	DEBUG("Loaded %d crew position%s", crewPositions_nstack, (crewPositions_nstack==1) ? "" : "s" );

	/* Load crew name generators. */

	lua_State *L;

	crew_name_lua = nlua_newState();
	L           = crew_name_lua;
	nlua_loadStandard(L, 1);
	buf         = ndata_read( CREW_NAME_DATA_PATH, &bufsize );
	if (luaL_dobuffer(crew_name_lua, buf, bufsize, CREW_NAME_DATA_PATH) != 0) {
		WARN( "Failed to load crew name file: %s\n"
				"%s\n"
				"Most likely Lua file has improper syntax, please check",
				CREW_NAME_DATA_PATH, lua_tostring(L,-1));
	}
	free(buf);

	return 0;
}

static int crewPosition_parse( CrewPosition *temp, xmlNodePtr parent )
{
	xmlNodePtr node;

	/* Clear memory. */
	memset( temp, 0, sizeof(CrewPosition) );

	/* Get name. */
	xmlr_attr( parent, "name", temp->name );
	if (temp->name == NULL)
		WARN("Crew position from "CREW_DATA_PATH" has invalid or no name");

	/* Parse body. */
	node = parent->xmlChildrenNode;
	do {
		xml_onlyNodes(node);

		if (xml_isNode(node,"crew")) {

			/* Make room for crew. */
			crews_stack = realloc(crews_stack,
					sizeof(Crew)*(++crews_nstack));

			/* Load crew. */
			crew_parse(&crews_stack[crews_nstack-1], node, temp);

			continue;
		}

		WARN("Crew position '%s' has unknown node '%s'.", temp->name, node->name);
	} while (xml_nextNode(node));

	return 0;
}

static int crew_parse( Crew *temp, xmlNodePtr parent, CrewPosition* position )
{
	xmlNodePtr cur,node;
	ShipStatList *ll;

	int i;

	/* Clear memory. */
	memset( temp, 0, sizeof(Crew) );

	temp->position=strdup(position->name);

	/* Parse body. */
	node = parent->xmlChildrenNode;
	do {
		xml_onlyNodes(node);
		xmlr_strd(node, "name", temp->name);
		xmlr_strd(node, "description", temp->description);
		xmlr_long(node, "hiring_price", temp->hiringPrice);
		xmlr_int(node, "level", temp->level);
		xmlr_int(node, "chance", temp->chance);

		if (xml_isNode(node,"gender")) {
			temp->gender = crew_gender( xml_get(node) );
			continue;
		}

		if (xml_isNode(node,"location")) {
			temp->loc = crew_location( xml_get(node) );
			continue;
		}

		xmlr_strd(node, "conditions", temp->cond);
		xmlr_strd(node, "portrait", temp->portrait);
		xmlr_strd(node, "name_generator", temp->nameGenerator);

		if (xml_isNode(node,"faction")) {
			temp->factions = realloc( temp->factions,
					sizeof(int) * ++temp->nfactions );
			temp->factions[temp->nfactions-1] =
					faction_get( xml_get(node) );

			if (temp->factions[temp->nfactions-1]==0) {
				WARN("Crew '%s' has unknown needed faction '%s'.", temp->name, xml_get(node));
			}
			continue;
		}

		xmlr_int(node, "combat_rating_needed", temp->combatRatingNeeded);

		if (xml_isNode(node,"faction_needed")) {
			temp->factionNeeded=faction_get( xml_get(node) );

			if (temp->factionNeeded==0) {
				WARN("Crew '%s' has unknown needed faction '%s'.", temp->name, xml_get(node));
			}
			continue;
		}

		xmlr_int(node, "faction_relation_needed", temp->factionRelationNeeded);

		/* Parse ship stats. */
		if (xml_isNode(node,"stats")) {
			cur = node->children;
			do {
				xml_onlyNodes(cur);
				ll = ss_listFromXML( cur );
				if (ll != NULL) {
					ll->next    = temp->stats;
					temp->stats = ll;
					continue;
				}
				WARN("Crew '%s' has unknown stat '%s'.", temp->name, cur->name);
			} while (xml_nextNode(cur));

			/* Load array. */
			ss_statsInit( &temp->stats_array );
			ss_statsModFromList( &temp->stats_array, temp->stats, NULL );

			/* Create description. */
			if (temp->stats != NULL) {
				temp->desc_stats = malloc( STATS_DESC_MAX );
				i = ss_statsListDesc( temp->stats, temp->desc_stats, STATS_DESC_MAX, 0 );
				if (i <= 0) {
					free( temp->desc_stats );
					temp->desc_stats = NULL;
				}
			}

			continue;
		}

		WARN("Crew '%s' has unknown node '%s'.", temp->name, node->name);
	} while (xml_nextNode(node));

#define MELEMENT(o,s)      if (o) WARN("Crew '%s' missing '"s"' element", temp->name)
	MELEMENT(temp->name==NULL,"name");
	MELEMENT(temp->description==NULL,"description");
	MELEMENT(temp->portrait==NULL,"portrait");
	MELEMENT(temp->stats==NULL,"stats");
	MELEMENT(temp->gender==0,"gender");
#undef MELEMENT

	if (temp->gender==0)
		temp->gender=3;

	//works because crew_get returns the first, so not temp if there is a duplicate.
	if (crew_get(temp->name)!=temp) {
		WARN("Crew '%s'is present multiple times. This is not allowed.", temp->name);
	}

	return 0;
}

Crew* crew_get( const char* name ) {
	Crew *temp;
	int i;

	temp = crews_stack;
	for (i=0; i < crews_nstack; i++)
		if (strcmp(temp[i].name, name)==0)
			return &temp[i];

	WARN("Crew %s does not exist", name);
	return NULL;
}

void crew_addToBar(const Planet* landPlanet) {
	int i;
	Crew* crew;
	char portrait[PATH_MAX];
	char barDesc[MAX_BAR_DESC];
	char *generatedName;
	double chance;
	char bufFaction[PATH_MAX],bufRating[PATH_MAX];

	for (i=0; i < crews_nstack; i++) {

		crew=&crews_stack[i];

		if (crew_checkBarConditions(crew,landPlanet)) {

			chance = (double)(crew->chance % 100)/100.;
			if (chance == 0.) /* We want to consider 100 -> 100% not 0% */
				chance = 1.;

			if (RNGF() < chance) {

				//only possible to have one crew of a "type", so shouldn't add other ones
				if (player_getCrew(crew->name)==NULL) {
					generatedName=crew_findName(crew->nameGenerator);

					nsnprintf( portrait, PATH_MAX, GFX_PATH"portraits/%s.png", crew->portrait );

					if (crew->combatRatingNeeded>0) {
						nsnprintf( bufRating, MAX_BAR_DESC, "Combat Rating Required: %s\n",
								player_rating_other(crew->combatRatingNeeded) );
					} else {
						nsnprintf( bufRating, MAX_BAR_DESC,"");
					}

					if (crew->factionNeeded>0) {
						nsnprintf( bufFaction, MAX_BAR_DESC, "Faction Required: %s\n"
								"Relations Required: %i\n",
								faction_longname(crew->factionNeeded),crew->factionRelationNeeded );
					} else {
						nsnprintf( bufFaction, MAX_BAR_DESC,"");
					}

					nsnprintf( barDesc, MAX_BAR_DESC, "Name: %s\nPosition: %s\nHiring Cost: %"CREDITS_PRI"\n"
							"Level: %s\n\n"
							"%s"
							"%s\n"
							"%s\n\nEffects when hired:\n\n%s",
							generatedName, crew->position, crew->hiringPrice, crew_getLevelName(crew->level),
							bufRating,bufFaction,
							crew->description, crew->desc_stats );

					npc_add_crew(crew, crew->name,
							10, portrait, barDesc, generatedName);
				}
			}
		}
	}
}

/**
 * @brief hires (or not) the crew once approached in the bar
 *
 * @param crew the crew to hire
 * @param generatedName the given name of that particular instance("John Smith", not "Old Pilot")
 * @return 1 if hired, 0 if not
 */
int crew_hireCrewFromBar(const Crew *crew, const char *generatedName) {

	if (crew->combatRatingNeeded>player.crating) {
		dialogue_msg("Insufficient Combat Rating",
				"Your combat rating of '%s' is insufficient for %s to agree to join your ship. "
				"A rating of '%s' is needed.",player_rating(),generatedName,player_rating_other(crew->combatRatingNeeded));
		return 0;
	}

	if (crew->factionNeeded>0) {
		if (faction_getPlayer(crew->factionNeeded) < crew->factionRelationNeeded) {
			dialogue_msg("Insufficient Relations",
					"Your relations with the %s are insufficient for %s to agree to join your ship. "
					"You need relations of %i or better, while you have relations of only %i.",
					faction_longname(crew->factionNeeded),generatedName,
					crew->factionRelationNeeded,(int)floor(faction_getPlayer(crew->factionNeeded)));
			return 0;
		}
	}

	if (!player_hasCredits(crew->hiringPrice)) {
		dialogue_msg("Crew member too expensive","You cannot afford the %"CREDITS_PRI" credits it would take to hire %s.",crew->hiringPrice,generatedName);
		return 0;
	}

	int choice;

	choice=dialogue_YesNo("Hire new crew member?","Do you wish to hire %s for %"CREDITS_PRI" credits?",generatedName,crew->hiringPrice);

	if (choice) {
		player_addCrew(crew,generatedName,1,-1);
		player_modCredits(-crew->hiringPrice);

		return 1;
	}

	return 0;
}

/**
 * @brief checks whether a crew member is valid for this bar
 *
 * @param crew to test
 * @param landPlanet where we are
 * @return 1 if valid, 0 otherwise
 */
static int crew_checkBarConditions(Crew* crew, const Planet* landPlanet) {

	int c;

	if (!crew_matchFaction(crew, landPlanet->faction))
		return 0;

	/* Must meet Lua condition. */
	if (crew->cond != NULL) {
		c = cond_check(crew->cond);
		if (c < 0) {
			WARN("Conditional for crew '%s' failed to run", crew->name);
			return 0;
		}
		else if (!c)
			return 0;
	}

	return 1;
}

/**
 * @brief Checks to see if a crew matches the faction requirements.
 *
 *    @param crew Crew to check.
 *    @param faction Faction to check against.
 *    @return 1 if it meets the faction requirement, 0 if it doesn't.
 */
static int crew_matchFaction( Crew* crew, int faction )
{
	int i;

	/* No faction always accepted. */
	if (crew->nfactions <= 0)
		return 1;

	/* Check factions. */
	for (i=0; i<crew->nfactions; i++)
		if (faction == crew->factions[i])
			return 1;

	return 0;
}

const HiredCrew* crew_getActiveCrewForPosition(const char* position) {
	int i,nbhcrews;
	const HiredCrew* hiredCrews;

	hiredCrews=player_getCrews(&nbhcrews);

	for (i=0;i<nbhcrews;i++) {
		if (hiredCrews[i].active && strcmp(hiredCrews[i].crew->position,position)==0) {
			return &hiredCrews[i];
		}
	}
	return NULL;
}


CrewPosition* crewPosition_get( const char* name ) {
	CrewPosition *temp;
	int i;

	temp = crewPositions_stack;
	for (i=0; i < array_size(crewPositions_stack); i++)
		if (strcmp(temp[i].name, name)==0)
			return &temp[i];

	WARN("Crew position %s does not exist", name);
	return NULL;
}

static int crew_location( const char* loc )
{
	if (strcmp(loc,"None")==0) return CREW_AVAIL_NONE;
	else if (strcmp(loc,"Bar")==0) return CREW_AVAIL_BAR;
	return -1;
}

static char* crew_findName( char* nameGenerator )
{
	int ret,errf;
	char func[MAX_FUNC_NAME];
	char* name;
	const char *err;
	lua_State *L;


	L = crew_name_lua;

   errf = 0;

	/* Set up function. */

	nsnprintf(func, MAX_FUNC_NAME, "get%sName", nameGenerator);

	lua_getglobal( L, func );

	ret = lua_pcall(L, 0, 1, errf);
   if (ret != 0) { /* error has occurred */
	  err = (lua_isstring(L,-1)) ? lua_tostring(L,-1) : NULL;
	  WARN("Crew getName -> '%s' : %s",func,
			(err) ? err : "unknown error");
	  lua_pop(L, 1);
   }

	if (lua_isstring(L,-1))
		name = strdup( lua_tostring(L,-1) );
	else {
		WARN( "Crew name generator: %s -> return parameter 1 is not a string!", func );
	}

	lua_pop(L,1);

	return name;
}

void crew_generateCrewLists(unsigned int wid) {
	int w, h;
	int i, pos, npositions;
	glTexture** tpositions;
	char** positions;
	const HiredCrew* hcrew;
	char portrait[PATH_MAX];
	int nActiveCrew = 0;
	int nReserveCrews;
	glTexture** tReserveCrews;
	char** reserveCrews;
	const HiredCrew* allCrews;
	int nAllCrews;

	/**
	 * If updating the window, need to clear the old lists
	 *
	 * TODO: save selection
	 */
	if (widget_exists( wid, "iarPositions" ))
		window_destroyWidget( wid, "iarPositions" );
	if (widget_exists( wid, "iarReserve" ))
		window_destroyWidget( wid, "iarReserve" );

	/* Get window dimensions. */
	window_dimWindow(wid, &w, &h);

	npositions = crewPositions_nstack;
	positions = malloc(sizeof(char*) * npositions);
	tpositions = malloc(sizeof(glTexture*) * npositions);

	for (i = 0; i < npositions; i++) {
		hcrew = crew_getActiveCrewForPosition(crewPositions_stack[i].name);
		if (hcrew != NULL) {
			positions[i] = strdup(hcrew->crew->name);
			nsnprintf(portrait, PATH_MAX, "dat/gfx/portraits/%s.png",
					hcrew->crew->portrait);
			nActiveCrew++;
		} else {
			positions[i] = strdup(crewPositions_stack[i].name);
			nsnprintf(portrait, PATH_MAX, "dat/gfx/portraits/empty.png");
		}
		tpositions[i] = gl_newImage(portrait, 0);
	}

	window_addImageArray(wid, 20, -40, w - 320 - 40 - 20, 400, "iarPositions",
			150, (150. / 200.) * 150., tpositions, positions, npositions,
			crew_update_active, crew_update_active);

	allCrews = player_getCrews(&nAllCrews);
	nReserveCrews = nAllCrews - nActiveCrew;
	reserveCrews = malloc(sizeof(char*) * nReserveCrews);
	tReserveCrews = malloc(sizeof(glTexture*) * nReserveCrews);
	pos = 0;

	for (i = 0; i < nAllCrews; i++) {
		if (!allCrews[i].active) {
			reserveCrews[pos] = strdup(allCrews[i].crew->name);
			nsnprintf(portrait, PATH_MAX, "dat/gfx/portraits/%s.png",
					allCrews[i].crew->portrait);
			tReserveCrews[pos] = gl_newImage(portrait, 0);
			pos++;
		}
	}

	window_addImageArray(wid, 20, -480, w - 320 - 40 - 20,
			h - 20 - 20 - 400 - 20 - 20 - 20, "iarReserve", 100, 75,
			tReserveCrews, reserveCrews, nReserveCrews, crew_update_reserve,
			crew_update_reserve);
}

/**
 * Screen methods
 */

void crew_open( unsigned int wid ) {

	/* Mark as generated. */
	land_tabGenerate(LAND_WINDOW_CREW);

	crew_generateCrewLists(wid);

	window_addText(wid, 30, -20, 130, 200, 0, "txtActiveCrew", &gl_defFont,
			&cBlack, "Active Crew");

	window_addText(wid, 30, -460, 130, 200, 0, "txtReserveCrew", &gl_defFont,
			&cBlack, "Reserve Crew");

	//Zoom on crew:

	window_addButtonKey( wid, -20, 20,
			320, 40, "btnCrewClose",
			"Take Off", land_buttonTakeoff, SDLK_t );

	window_addText( wid, -20, -20,
			320, gl_defFont.h, 1,
			"txtPortrait", &gl_defFont, &cDConsole, NULL );

	/* Crew zoom pict */
	window_addRect( wid, -80, -40,
			200, 150, "rctCrewZoom", &cBlack, 0 );
	window_addImage( wid, -80, -40,
			200, 150, "imgCrewZoom", NULL, 1 );

	window_addText( wid, -20, -210, 320, 120, 0,
			"txtLabelCrewZoom", &gl_smallFont, &cDConsole,
			"Name:\n"
			"Position:\n"
			"Level:\n");
	window_addText( wid, -20, -210, 160, 120, 0,
			"txtCrewZoom", &gl_smallFont, &cBlack, NULL );

	window_addText( wid, -20, -270, 320, 200, 0,
			"txtCrewZoomDesc", &gl_smallFont, &cBlack,
			NULL);

	window_addButtonKey( wid, -20-170, 80,
			150, 40, "btnCrewActivate",
			"Active Service", crew_setCrewActive, SDLK_a );

	window_addButtonKey( wid, -20, 80,
			150, 40, "btnCrewReserve",
			"Make Reserve", crew_setCrewReserve, SDLK_r );

	window_setFocus( wid , "iarPositions" );
}


static void crew_setCrewActive( unsigned int wid, char* str ) {
	(void)str;
	char *crewName;
	const HiredCrew* hcrew;
	int i;
	const HiredCrew* allCrews;
	int nAllCrews;

	//We're setting a crew to active, so it comes from the reserve list
	crewName = toolkit_getImageArray( wid, "iarReserve" );

	if (crewName!=NULL) {
		hcrew = player_getCrew(crewName);

		//need to set to reserve anybody holding the same post
		allCrews = player_getCrews(&nAllCrews);
		for (i = 0; i < nAllCrews; i++) {
			if (strcmp(allCrews[i].crew->position,hcrew->crew->position)==0) {
				player_setCrewActiveStatus(allCrews[i].crew->name,0);
			}
		}

		player_setCrewActiveStatus(crewName,1);

		pilot_calcStats( player.p );

		crew_generateCrewLists(wid);
	}
}

/**
 * @brief shifts an active crew member to reserve
 */
static void crew_setCrewReserve( unsigned int wid, char* str ) {
	(void)str;
	char *crewName;

	//We're setting a crew to reserve, so it comes from the active list
	crewName = toolkit_getImageArray( wid, "iarPositions" );

	if (crewName!=NULL) {
		player_setCrewActiveStatus(crewName,0);

		pilot_calcStats( player.p );

		crew_generateCrewLists(wid);
	}
}



/**
 * @brief Updates the crew selected, coming from active list
 *    @param wid Window to update
 *    @param str Unused.
 */
void crew_update_active( unsigned int wid, char* str ) {
	(void)str;//to get rid of unused compile warning.

	char *crewName;
	crewName = toolkit_getImageArray( wid, "iarPositions" );

	if (crewName!=NULL)
		display_crew(wid,crewName);
}

/**
 * @brief Updates the crew selected, coming from reserve list
 *    @param wid Window to update
 *    @param str Unused.
 */
void crew_update_reserve( unsigned int wid, char* str ) {
	(void)str;//to get rid of unused compile warning.

	char *crewName;
	crewName = toolkit_getImageArray( wid, "iarReserve" );

	if (crewName!=NULL)
		display_crew(wid,crewName);
}

/**
 * @brief Updates the ships in the shipyard window.
 *    @param wid Window to update the ships in.
 *    @param str Unused.
 */
static void display_crew(unsigned int wid, char* crewName) {
	const HiredCrew* hiredCrew;
	char buf[PATH_MAX];

	hiredCrew=player_getCrew(crewName);

	if (hiredCrew!=NULL) {
		window_modifyText( wid, "txtPortrait", hiredCrew->crew->name );

		nsnprintf( buf, PATH_MAX,
				"%s\n"
				"%s\n%s",hiredCrew->generatedName,hiredCrew->crew->position,crew_getLevelName(hiredCrew->crew->level));
		window_modifyText( wid, "txtCrewZoom", buf );

		nsnprintf( buf, PATH_MAX,
				"%s\n"
				"\n"
				"Effects on ship:\n"
				"\n"
				"%s",hiredCrew->crew->description,hiredCrew->crew->desc_stats);
		window_modifyText( wid, "txtCrewZoomDesc", buf );

		nsnprintf( buf, PATH_MAX, GFX_PATH"portraits/%s.png", hiredCrew->crew->portrait);

		window_modifyImage( wid, "imgCrewZoom", gl_newImage(buf,0), 200, 150 );

		if (hiredCrew->active) {
			window_enableButton( wid, "btnCrewReserve");
			window_disableButtonSoft( wid, "btnCrewActivate");
		} else {
			window_enableButton( wid, "btnCrewActivate");
			window_disableButtonSoft( wid, "btnCrewReserve");
		}
	} else {
		window_modifyText( wid, "txtPortrait", "" );
		window_modifyText( wid, "txtCrewZoom", "" );
		window_modifyText( wid, "txtCrewZoomDesc", "" );

		nsnprintf(buf, PATH_MAX, "dat/gfx/portraits/empty.png");
		window_modifyImage( wid, "imgCrewZoom", gl_newImage(buf,0), 200, 150 );

		window_disableButtonSoft( wid, "btnCrewActivate");
		window_disableButtonSoft( wid, "btnCrewReserve");
	}
}

static char* crew_getLevelName(int level) {

	if (level<=1) {
		return "Amateur";
	} else if (level==2) {
		return "Professional";
	} else if (level==3) {
		return "Master";
	} else {
		return "Legend";
	}
}

static int crew_gender( char* genderName ) {
	if (strcmp(genderName,"male")==0) {
		return 1;
	} else if (strcmp(genderName,"female")==0) {
		return 2;
	} else if (strcmp(genderName,"neutral")==0) {
		return 3;
	} else {
		WARN("Unknown gender '%s', defaulting to neutral.", genderName);
		return 3;
	}
}

char* crew_getGenderPronoun(const Crew* crew) {

	if (crew->gender==1) {
		return "he";
	} else if (crew->gender==2) {
		return "she";
	} else {
		return "it";
	}
}



