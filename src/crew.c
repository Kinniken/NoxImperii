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
static void crew_fireCrew( unsigned int wid, char* str );
static char* crew_getLevelName(int level);
static int crew_gender( char* genderName );
static char* crew_getStatusNameColoured(int status);
static int crew_checkBarConditions(Crew* crew, const Planet* landPlanet);
static int crew_matchFaction( Crew* crew, int faction );

static char* getColouredRequiredRating(const Crew* crew,char* buf);
static char* getColouredRequiredRelations(const Crew* crew,char* buf);
static char* getColouredPrice(const Crew* crew,char* buf);
static glTexture** getCrewLayers(const Crew* crew, int* nlayers);
static void getCrewEmptyLayers(glTexture*** layers, int* nlayers);

static ntime_t last_crew_payment = 0;

static nlua_env crew_name_env = LUA_NOREF;  /** Crew name generators */

static const HiredCrew* selectedCrew = NULL;

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

	crew_name_env = nlua_newEnv(1);
	nlua_loadStandard(crew_name_env);

	buf         = ndata_read( CREW_NAME_DATA_PATH, &bufsize );
	if (nlua_dobufenv(crew_name_env, buf, bufsize, CREW_NAME_DATA_PATH) != 0) {
		WARN( "Failed to load crew name file: %s\n"
				"%s\n"
				"Most likely Lua file has improper syntax, please check",
				CREW_NAME_DATA_PATH, lua_tostring(naevL,-1));
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
		xmlr_long(node, "monthly_salary", temp->monthlySalary);
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
		xmlr_strd(node, "background", temp->background);
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
	char barDesc[MAX_BAR_DESC];
	char *generatedName;
	double chance;
	char bufFaction[PATH_MAX],bufRating[PATH_MAX],buf[PATH_MAX];
	glTexture **layers;
	int nlayers;

	for (i=0; i < crews_nstack; i++) {

		crew=&crews_stack[i];

		if (crew_checkBarConditions(crew,landPlanet)) {

			chance = (double)(crew->chance % 100)/100.;
			if (chance == 0.) /* We want to consider 100 -> 100% not 0% */
				chance = 1.;

			if (RNGF() < chance) {

				//only possible to have one crew of a "type", so shouldn't add other ones
				if (player_getCrew(crew->name)==NULL) {
					if (crew->nameGenerator != NULL)
						generatedName=crew_findName(crew->nameGenerator);
					else {//named characters, from missions
						generatedName=crew->name;
					}

					if (crew->combatRatingNeeded>0) {
						nsnprintf( bufRating, MAX_BAR_DESC, "\eDCombat Rating Required:\e0 %s\n",
								getColouredRequiredRating(crew,buf) );
					} else {
						nsnprintf( bufRating, MAX_BAR_DESC,"");
					}

					if (crew->factionNeeded>0) {
						nsnprintf( bufFaction, MAX_BAR_DESC, "\eDFaction Required:\e0 %s\n"
								"\eDRelations Required:\e0 %s\n",
								faction_longname(crew->factionNeeded),getColouredRequiredRelations(crew,buf) );
					} else {
						nsnprintf( bufFaction, MAX_BAR_DESC,"");
					}

					nsnprintf( barDesc, MAX_BAR_DESC, "\eDName:\e0 %s\n\eDPosition:\e0 %s\n\eDHiring Cost:\e0 %s\n\eDMonthly Salary:\e0 %"CREDITS_PRI"\n"
							"\eDLevel:\e0 %s\n\n"
							"%s"
							"%s\n"
							"%s\n\nEffects when hired:\n\n%s",
							generatedName, crew->position, getColouredPrice(crew,buf), crew->monthlySalary, crew_getLevelName(crew->level),
							bufRating,bufFaction,
							crew->description, crew->desc_stats );

					layers=getCrewLayers(crew,&nlayers);

					npc_add_crew(crew, crew->name,
							10, layers, nlayers, barDesc, generatedName);
				}
			}
		}
	}
}

static char* getColouredRequiredRating(const Crew* crew,char* buf) {

	if (player.crating < crew->combatRatingNeeded) {
		nsnprintf( buf, PATH_MAX,"\er%s\e0",player_rating_other(crew->combatRatingNeeded) );
		return buf;
	} else {
		strcpy(buf,player_rating_other(crew->combatRatingNeeded));
		return buf;
	}
}

static char* getColouredRequiredRelations(const Crew* crew,char* buf) {

	if (faction_getPlayer(crew->factionNeeded) < crew->factionRelationNeeded) {
		nsnprintf( buf, PATH_MAX,"\er%i\e0",crew->factionRelationNeeded );
		return buf;
	} else {
		nsnprintf( buf, PATH_MAX,"%i",crew->factionRelationNeeded );
				return buf;
	}
}

static char* getColouredPrice(const Crew* crew,char* buf) {

	if (!player_hasCredits(crew->hiringPrice)) {
		nsnprintf( buf, PATH_MAX,"\er%"CREDITS_PRI"\e0",crew->hiringPrice );
		return buf;
	} else {
		nsnprintf( buf, PATH_MAX,"%"CREDITS_PRI,crew->hiringPrice );
				return buf;
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
		player_addCrew(crew,generatedName,1,-1,HCREW_STATUS_OK);
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

HiredCrew* crew_getActiveCrewForPosition(const char* position) {
	int i,nbhcrews;
	HiredCrew* hiredCrews;

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
	int ret;
	char func[MAX_FUNC_NAME];
	char* name;
	const char *err;

	/* Set up function. */

	nsnprintf(func, MAX_FUNC_NAME, "get%sName", nameGenerator);

	nlua_getenv(crew_name_env,func);
	ret = nlua_pcall(crew_name_env, 0, 1);

   if (ret != 0) { /* error has occurred */
	  err = (lua_isstring(naevL,-1)) ? lua_tostring(naevL,-1) : NULL;
	  WARN("Crew getName -> '%s' : %s",func,
			(err) ? err : "unknown error");
	  lua_pop(naevL, 1);
   }

	if (lua_isstring(naevL,-1))
		name = strdup( lua_tostring(naevL,-1) );
	else {
		WARN( "Crew name generator: %s -> return parameter 1 is not a string!", func );
	}

	lua_pop(naevL,1);

	return name;
}


static glTexture** getCrewLayers(const Crew* crew, int* nlayers) {

	char buf[PATH_MAX];
	int pos=0;

	if (crew->background == NULL) {
		*nlayers=3;
	} else {
		*nlayers=4;
	}

	glTexture** layers=malloc( sizeof(glTexture *) * (*nlayers) );

	if (crew->background != NULL) {
		nsnprintf( buf, PATH_MAX, GFX_PATH"portraits/%s.png", crew->background);
		layers[pos]=gl_newImage(buf,0);
		pos++;
	}

	nsnprintf( buf, PATH_MAX, GFX_PATH"portraits/%s.png", crew->portrait);
	layers[pos]=gl_newImage(buf,0);
	pos++;

	nsnprintf( buf, PATH_MAX, GFX_PATH"portraits/crewlayers/stars%d.png", crew->level);
	layers[pos]=gl_newImage(buf,0);
	pos++;

	nsnprintf( buf, PATH_MAX, GFX_PATH"portraits/crewlayers/positions/%s.png", crew->position);
	layers[pos]=gl_newImage(buf,0);

	return layers;
}

static void getCrewEmptyLayers(glTexture*** layers, int* nlayers) {
	char buf[PATH_MAX];

	nsnprintf(buf, PATH_MAX, "dat/gfx/portraits/empty.png");

	*layers=malloc( sizeof(glTexture *) * 1 );

	glTexture **portraitLayers=*layers;

	portraitLayers[0]=gl_newImage(buf,0);

	*nlayers=1;
}


void crew_generateCrewLists(unsigned int wid) {
	int w, h;
	int i, pos, npositions;
	glTexture*** tpositions;
	int* positionsnLayers;
	char** positions;
	const HiredCrew* hcrew;
	int nActiveCrew = 0;
	int nReserveCrews;
	glTexture*** tReserveCrews;
	int* reserveCrewsnLayers;
	char** reserveCrews;
	const HiredCrew* allCrews;
	int nAllCrews;

	/**
	 * If updating the window, need to clear the old lists
	 */
	if (widget_exists( wid, "iarPositions" ))
		window_destroyWidget( wid, "iarPositions" );
	if (widget_exists( wid, "iarReserve" ))
		window_destroyWidget( wid, "iarReserve" );

	/* Get window dimensions. */
	window_dimWindow(wid, &w, &h);

	npositions = crewPositions_nstack;
	positions = malloc(sizeof(char*) * npositions);
	tpositions = malloc(sizeof(glTexture**) * npositions);
	positionsnLayers = malloc(sizeof(int) * npositions);

	for (i = 0; i < npositions; i++) {
		hcrew = crew_getActiveCrewForPosition(crewPositions_stack[i].name);
		if (hcrew != NULL) {
			positions[i] = strdup(hcrew->crew->name);

			tpositions[i]=getCrewLayers(hcrew->crew,&positionsnLayers[i]);

			nActiveCrew++;
		} else {
			positions[i] = strdup(crewPositions_stack[i].name);

			getCrewEmptyLayers(&tpositions[i],&positionsnLayers[i]);
		}
	}

	window_addImageLayeredArray(wid, 20, -40, w - 320 - 40 - 20, 400, "iarPositions",
			150, (150. / 200.) * 150., tpositions, positionsnLayers, positions, npositions,
			crew_update_active, crew_update_active);

	allCrews = player_getCrews(&nAllCrews);
	nReserveCrews = nAllCrews - nActiveCrew;
	reserveCrews = malloc(sizeof(char*) * nReserveCrews);
	tReserveCrews = malloc(sizeof(glTexture*) * nReserveCrews);
	reserveCrewsnLayers = malloc(sizeof(int) * nReserveCrews);
	pos = 0;

	for (i = 0; i < nAllCrews; i++) {
		if (!allCrews[i].active) {
			reserveCrews[pos] = strdup(allCrews[i].crew->name);

			tReserveCrews[pos]=getCrewLayers(allCrews[i].crew,&reserveCrewsnLayers[pos]);

			pos++;
		}
	}

	window_addImageLayeredArray(wid, 20, -480, w - 320 - 40 - 20,
			h - 20 - 20 - 400 - 20 - 20 - 20, "iarReserve", 100, 75,
			tReserveCrews, reserveCrewsnLayers, reserveCrews, nReserveCrews, crew_update_reserve,
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
	window_addImageLayered( wid, -80, -40,
			200, 150, "imgCrewZoom", NULL, 0, 1 );

	window_addText( wid, -20, -210, 320, 120, 0,
			"txtLabelCrewZoom", &gl_smallFont, &cDConsole,
			"Name:\n"
			"Position:\n"
			"Level:\n"
			"Status:\n"
			"Monthly Salary:\n");
	window_addText( wid, -20, -210, 160, 120, 0,
			"txtCrewZoom", &gl_smallFont, &cBlack, NULL );

	window_addText( wid, -20, -285, 320, 200, 0,
			"txtCrewZoomDesc", &gl_smallFont, &cBlack,
			NULL);

	window_addButtonKey( wid, -20-226, 80,
			94, 40, "btnCrewActivate",
			"Active", crew_setCrewActive, SDLK_a );

	window_addButtonKey( wid, -20-113, 80,
			93, 40, "btnCrewReserve",
			"Reserve", crew_setCrewReserve, SDLK_r );

	window_addButtonKey( wid, -20, 80,
				93, 40, "btnFireCrew",
				"Fire", crew_fireCrew, SDLK_f );

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
	crewName = toolkit_getImageLayeredArray( wid, "iarReserve" );

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
	crewName = toolkit_getImageLayeredArray( wid, "iarPositions" );

	if (crewName!=NULL) {
		player_setCrewActiveStatus(crewName,0);

		pilot_calcStats( player.p );

		crew_generateCrewLists(wid);
	}
}


/**
 * @brief fires a crew member
 */
static void crew_fireCrew( unsigned int wid, char* str ) {
	(void)str;
	int choice;


	if (selectedCrew!=NULL) {

		choice=dialogue_YesNo("Fire crew member?","Do you wish to fire %s?",selectedCrew->generatedName);

		if (choice==1) {
			player_rmCrew(selectedCrew->crew);

			pilot_calcStats( player.p );

			crew_generateCrewLists(wid);

			display_crew(wid,"");
		}
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
	crewName = toolkit_getImageLayeredArray( wid, "iarPositions" );

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
	crewName = toolkit_getImageLayeredArray( wid, "iarReserve" );

	if (crewName!=NULL)
		display_crew(wid,crewName);
}

/**
 * @brief Updates the ships in the shipyard window.
 *    @param wid Window to update the ships in.
 *    @param crewName crew to display.
 */
static void display_crew(unsigned int wid, char* crewName) {
	const HiredCrew* hiredCrew;
	char buf[PATH_MAX];

	hiredCrew=player_getCrew(crewName);

	if (hiredCrew!=NULL) {
		window_modifyText( wid, "txtPortrait", hiredCrew->crew->name );

		nsnprintf( buf, PATH_MAX,
				"%s\n"
				"%s\n"
				"%s\n"
				"%s\n"
				"%"CREDITS_PRI" cr",hiredCrew->generatedName,
				hiredCrew->crew->position,
				crew_getLevelName(hiredCrew->crew->level),
				crew_getStatusNameColoured(hiredCrew->status),
				hiredCrew->crew->monthlySalary
		);
		window_modifyText( wid, "txtCrewZoom", buf );

		nsnprintf( buf, PATH_MAX,
				"%s\n"
				"\n"
				"Effects on ship:\n"
				"\n"
				"%s",hiredCrew->crew->description,hiredCrew->crew->desc_stats);
		window_modifyText( wid, "txtCrewZoomDesc", buf );

		glTexture **portraitLayers;
		int nlayers;

		portraitLayers=getCrewLayers(hiredCrew->crew, &nlayers);

		window_modifyImageLayered( wid, "imgCrewZoom",portraitLayers, nlayers, 200, 150 );

		if (hiredCrew->active) {
			window_enableButton( wid, "btnCrewReserve");
			window_disableButtonSoft( wid, "btnCrewActivate");
		} else {
			window_enableButton( wid, "btnCrewActivate");
			window_disableButtonSoft( wid, "btnCrewReserve");
		}
		window_enableButton( wid, "btnFireCrew");

		selectedCrew = hiredCrew;

	} else {
		window_modifyText( wid, "txtPortrait", "" );
		window_modifyText( wid, "txtCrewZoom", "" );
		window_modifyText( wid, "txtCrewZoomDesc", "" );

		glTexture **portraitLayers;
		int nlayers;

		getCrewEmptyLayers(&portraitLayers, &nlayers);

		window_modifyImageLayered( wid, "imgCrewZoom", portraitLayers, nlayers, 200, 150 );

		window_disableButtonSoft( wid, "btnCrewActivate");
		window_disableButtonSoft( wid, "btnCrewReserve");
		window_disableButtonSoft( wid, "btnFireCrew");

		selectedCrew = NULL;
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

static char* crew_getStatusNameColoured(int status) {

	if (status==HCREW_STATUS_OK) {
		return "Healthy";
	} else if (status==HCREW_STATUS_WOUNDED) {
		return "\erWounded\e0";
	} else {
		WARN("Unknown status '%s'.", status);
		return "UNKNOWN";
	}
}

static int crew_gender( char* genderName ) {
	if (strcmp(genderName,"male")==0) {
		return CREW_GENDER_MALE;
	} else if (strcmp(genderName,"female")==0) {
		return CREW_GENDER_FEMALE;
	} else if (strcmp(genderName,"neutral")==0) {
		return CREW_GENDER_NEUTRAL;
	} else {
		WARN("Unknown gender '%s', defaulting to neutral.", genderName);
		return CREW_GENDER_NEUTRAL;
	}
}

char* crew_getGenderPronoun(const Crew* crew) {

	if (crew->gender==CREW_GENDER_MALE) {
		return "he";
	} else if (crew->gender==CREW_GENDER_FEMALE) {
		return "she";
	} else {
		return "it";
	}
}

void crew_checkForSalaryPayment(void) {
	int sec,min,hour,day,month,year;
	int sec2,min2,hour2,day2,month2,year2;

	int i;
	credits_t totalSalaries = 0;


	ntime_getBreakdown(ntime_get(), &year,&month,&day,&hour,&min,&sec);
	ntime_getBreakdown(last_crew_payment, &year2,&month2,&day2,&hour2,&min2,&sec2);

	if (year>year2 || month>month2) {
		last_crew_payment=ntime_get();

		const HiredCrew* allCrews;
		int nAllCrews;

		allCrews = player_getCrews(&nAllCrews);
		for (i = 0; i < nAllCrews; i++) {
			totalSalaries += allCrews[i].crew->monthlySalary;
		}

		if (totalSalaries > 0) {
			dialogue_msg("Pay Day!",
							"A new month is starting, and the crew of the %s is due its salaries. "
							"The total comes to %"CREDITS_PRI" credits.",player.p->name,totalSalaries);
			player_modCredits( (credits_t)round(-totalSalaries) );
		}
	}
}

void crew_setCrewPaymentTime( ntime_t timeVal ) {
	last_crew_payment = timeVal;
}

ntime_t crew_getCrewPaymentTime( void ) {
	return last_crew_payment;
}


