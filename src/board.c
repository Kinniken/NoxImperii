/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file board.c
 *
 * @brief Deals with boarding ships.
 */


#include "board.h"

#include "naev.h"

#include "log.h"
#include "pilot.h"
#include "player.h"
#include "toolkit.h"
#include "space.h"
#include "rng.h"
#include "economy.h"
#include "hook.h"
#include "damagetype.h"
#include "nstring.h"
#include "limits.h"
#include "ndata.h"
#include "dialogue.h"


#define TABLE_WIDTH  (120*4+20) /**< Loot tables width. */
#define TABLE_HEIGHT (120*2+10) /**< Loot tables height. */

#define BUTTON_WIDTH     100 /**< Boarding button width. */
#define BUTTON_HEIGHT    30 /**< Boarding button height. */


static int board_stopboard = 0; /**< Whether or not to unboard. */
static int board_boarded   = 0;

int nloots=0;
Loot* loots;
ntime_t totalTime;

/*
 * prototypes
 */
static void board_createLootLists(const unsigned int wid);
static void board_computeLoots(Pilot* p);
static int board_trySteal( Pilot *p );
static int board_fail(void);
static void board_createWindow(Pilot* p);

/**
 * @brief Gets if the player is boarded.
 */
int player_isBoarded (void)
{
   return board_boarded;
}

/**
 * @brief creates the window
 */
static void board_createWindow(Pilot* p) {

	unsigned int wid;
	/*
	 * create the boarding window
	 */
	wid = window_create("Boarding", -1, -1, TABLE_WIDTH + 40 + 128 + 140,
			TABLE_HEIGHT * 2 + BUTTON_HEIGHT * 2 + 80);

	window_addButtonKey(wid, 20, -20 - TABLE_HEIGHT - 25, BUTTON_WIDTH,
			BUTTON_HEIGHT, "btnBoardingTake", "Take", board_take, SDLK_t);

	window_addButtonKey(wid, 20 + BUTTON_WIDTH + 20, -20 - TABLE_HEIGHT - 25,
			BUTTON_WIDTH, BUTTON_HEIGHT, "btnBoardingRemove", "Remove",
			board_remove, SDLK_r);

	window_addText( wid, -20, -20, 128+80, 30, 1,
				"txtLootZoomTitle", &gl_smallFont, &cDConsole,"");

	window_addRect(wid, -80, -60, 128, 128, "rctLootZoom", &cBlack, 0);
	window_addImageLayered(wid, -80, -60, 128, 128, "imgLootZoom", NULL, 0, 1);

	window_addText( wid, -20, -60-128-20, 128+120, 120, 0,
					"txtLootZoomLabels", &gl_smallFont, &cDConsole,"Quantity:\nTotal value:\nTime needed:\n");

	window_addText( wid, -20, -60-128-20, 120, 120, 0,
						"txtLootZoomDesc", &gl_smallFont, &cDConsole,"");

	window_addText( wid, -20, -60-128-20-50, 128+120, 120, 0,
						"txtLootZoomImpossible", &gl_smallFont, &cDarkRed,"");

	window_addText( wid, 20, 20, TABLE_WIDTH, 30, 1,
					"txtTotalTime", &gl_smallFont, &cBlack,"");


	window_addButtonKey(wid, -20-BUTTON_WIDTH-20, 20, BUTTON_WIDTH, BUTTON_HEIGHT,
			"btnBoardingLoot", "Loot", board_startLoot, SDLK_l);
	window_addButtonKey(wid, -20, 20, BUTTON_WIDTH, BUTTON_HEIGHT,
				"btnBoardingClose", "Leave", board_exit, SDLK_e);

	board_computeLoots(p);
	board_createLootLists(wid);
	board_listUpdate( wid, NULL );
}

/**
 * @fn void player_board (void)
 *
 * @brief Attempt to board the player's target.
 *
 * Creates the window on success.
 */
void player_board (void)
{
   Pilot *p;
   char c;
   HookParam hparam[2];
   int answer;
   char buf[512];
   int chance;

   /* Not disabled. */
   if (pilot_isDisabled(player.p))
      return;

   if (player.p->target==PLAYER_ID) {
      /* We don't try to find far away targets, only nearest and see if it matches.
       * However, perhaps looking for first boardable target within a certain range
       * could be more interesting. */
      player_targetNearest();
      p = pilot_get(player.p->target);
      if ((!pilot_isDisabled(p) && !pilot_isFlag(p,PILOT_BOARDABLE)) ||
            pilot_isFlag(p,PILOT_NOBOARD)) {
         player_targetClear();
         player_message("\erYou need a target to board first!");
         return;
      }
   }
   else
      p = pilot_get(player.p->target);
   c = pilot_getFactionColourChar( p );

   /* More checks. */
   if (pilot_isFlag(p,PILOT_NOBOARD)) {
      player_message("\erTarget ship can not be boarded.");
      return;
   }
   else if (pilot_isFlag(p,PILOT_BOARDED_FAILED)) {
      player_message("\erYour target cannot be boarded again.");
      return;
   }
   else if (!pilot_isDisabled(p) && !pilot_isFlag(p,PILOT_BOARDABLE)) {
      player_message("\erYou cannot board a ship that isn't disabled!");
      return;
   }
   else if (vect_dist(&player.p->solid->pos,&p->solid->pos) >
         p->ship->gfx_space->sw * PILOT_SIZE_APROX) {
      player_message("\erYou are too far away to board your target.");
      return;
   }
   else if ((pow2(VX(player.p->solid->vel)-VX(p->solid->vel)) +
            pow2(VY(player.p->solid->vel)-VY(p->solid->vel))) >
         (double)pow2(MAX_HYPERSPACE_VEL)) {
      player_message("\erYou are going too fast to board the ship.");
      return;
   }
   /* We'll recover it if it's the pilot's ex-escort. */
   else if (p->parent == PLAYER_ID) {
      /* Try to recover. */
      pilot_dock( p, player.p, 0 );
      if (pilot_isFlag(p, PILOT_DELETE )) { /* Hack to see if it boarded. */
         player_message("\epYou recover \eg%s\ep into your fighter bay.", p->name);
         return;
      }
   }

   if (p == NULL)
	   return;

   //If has not been boarded before, needs to fight for it
   if (!pilot_isFlag(p,PILOT_BOARDED_SUCCESS)) {
	   chance=100-(0.4 * (5. + p->crew*p->boarding_skills)/(5. + player.p->crew*player.p->boarding_skills))*100;
	   chance=MAX(chance,0);
	   chance=MIN(chance,100);

	   nsnprintf( buf, 512, "Do you wish to attempt to board the %s?"
			   "\n\nYou have a crew of %d fighting at %d%% efficiency."
			   "\n\nThey have a crew of %d fighting at %d%% efficiency."
			   "\n\nYour chance of winning are of %d%%.", p->name,
			   (int)player.p->crew,(int)(player.p->boarding_skills*100),
			   (int)p->crew,(int)(p->boarding_skills*100),
			   chance);

	   answer = dialogue_YesNoRaw("Boarding Attempt",buf);

	   if (answer == 0)
		   return;

	   answer = board_fail();

	   if (answer == 1)
		   return;
   }

   /* Is boarded. */
   board_boarded = 1;

   /* pilot will be boarded */
   pilot_setFlag(p,PILOT_BOARDED_SUCCESS);
   pilot_setFlag(p,PILOT_BOARDED_IP);

   player_message("\epBoarding ship \e%c%s\e0.", c, p->name);

   /* Don't unboard. */
   board_stopboard = 0;

   /*
    * run hook if needed
    */
   hparam[0].type       = HOOK_PARAM_PILOT;
   hparam[0].u.lp       = p->id;
   hparam[1].type       = HOOK_PARAM_SENTINEL;
   hooks_runParam( "board", hparam );
   pilot_runHookParam(p, PILOT_HOOK_BOARD, hparam, 1);
   hparam[0].u.lp       = PLAYER_ID;
   pilot_runHookParam(p, PILOT_HOOK_BOARDING, hparam, 1);

   if (board_stopboard) {
      board_boarded = 0;
      return;
   }

   /*
    * create the boarding window
    */
	board_createWindow(p);
}

/**
 * @brief recreates the two image arrays
 */
static void board_createLootLists(const unsigned int wid) {

	int i;
	int* ntloots;
	glTexture ***tloots;
	char **loots_name;
	char **loots_quantity;
	int nb, pos;
	char buf[256],buf2[128],buf3[128];
	credits_t totalValue;

	if (widget_exists( wid, "iarLoots" ))
		window_destroyWidget( wid, "iarLoots" );
	if (widget_exists( wid, "iarLootsSelected" ))
		window_destroyWidget( wid, "iarLootsSelected" );

	//First, non-selected loots
	nb=0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 0)
			nb++;
	}

	loots_name = malloc(sizeof(char*) * nb);
	loots_quantity = malloc(sizeof(char*) * nb);
	ntloots = malloc(sizeof(int*)* nb);
	tloots    = malloc(sizeof(glTexture**) * nb);

	pos=0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 0) {
			loots_name[pos]=strdup(loots[i].label);

			loots_quantity[pos] = malloc( loots[i].quantity / 10 + 4 );
			nsnprintf( loots_quantity[pos], loots[i].quantity / 10 + 4, "%d", loots[i].quantity );

			ntloots[pos] = loots[i].ntexture;
			tloots[pos] = loots[i].textures;

			pos++;
		}
	}

	window_addImageLayeredArray( wid, 20, -30,
			TABLE_WIDTH, TABLE_HEIGHT, "iarLoots", 96, 96,
			tloots, ntloots, loots_name, nb, board_listUpdate, board_listUpdate );
	toolkit_setImageLayeredArrayQuantity( wid, "iarLoots", loots_quantity );

	//Now, the rest
	nb=0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 1)
			nb++;
	}

	loots_name = malloc(sizeof(char*) * nb);
	ntloots = malloc(sizeof(int*)* nb);
	tloots    = malloc(sizeof(glTexture**) * nb);
	loots_quantity = malloc(sizeof(char*) * nb);

	pos=0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 1) {
			loots_name[pos]=strdup(loots[i].label);

			loots_quantity[pos] = malloc( loots[i].quantity / 10 + 4 );
			nsnprintf( loots_quantity[pos], loots[i].quantity / 10 + 4, "%d", loots[i].quantity );

			ntloots[pos] = loots[i].ntexture;
			tloots[pos] = loots[i].textures;

			pos++;
		}
	}

	window_addImageLayeredArray( wid, 20, -20-TABLE_HEIGHT-20-BUTTON_HEIGHT-20,
				TABLE_WIDTH, TABLE_HEIGHT, "iarLootsSelected", 96, 96,
				tloots, ntloots, loots_name, nb, board_listUpdateSelected, board_listUpdateSelected );
	toolkit_setImageLayeredArrayQuantity( wid, "iarLootsSelected", loots_quantity );

	totalTime = 0;
	totalValue = 0;

	for (i=0; i<nloots; i++) {
			if (loots[i].selected == 1) {
				totalTime += loots[i].timeNeeded;
				totalValue += loots[i].totalValue;
			}
	}


	if (totalTime>0) {
		ntime_prettyBuf(buf2,128,totalTime,1);
		credits2str( buf3, totalValue, 2 );

		for (i=0; i<nloots; i++) {
			if (loots[i].selected == 1) {
				totalTime += loots[i].timeNeeded;
			}
		}

		nsnprintf( buf, 256,
				"Total time needed to loot items: %s\nTotal value: %s",
				buf2,buf3
		);
		window_modifyText( wid, "txtTotalTime", buf );
	} else {
		window_modifyText( wid, "txtTotalTime", "" );
	}
}

/*
 * @brief calculates the list of lootable items on the target ship
 */
static void board_computeLoots(Pilot* p) {
	int posNormal,posImpossible,pos;
	char buf[PATH_MAX];
	int i,slotSize;
	double crewSize;
	int impossibleStart=0;

	totalTime=0;

	crewSize = player.p->crew;

	nloots=0;

	if (p->credits > 0)
		nloots++;

	if (p->fuel > 0)
		nloots++;

	nloots += p->ncommodities;

	//For some reasons, some p->outfits[i] can have a null outfit, must skip those
	for (i=0;i<p->noutfits;i++) {
		if (p->outfits[i]->outfit != NULL)
			nloots++;
	}

	//Now calculating whether we have "impossible" items
	impossibleStart=nloots;

	if (p->fuel > 0 && player.p->fuel >= player.p->fuel_max)
		impossibleStart--;

	if (player.p->cargo_free == 0) {
		impossibleStart-=p->ncommodities;
	}

	loots = malloc(sizeof(Loot) * nloots);
	memset( loots, 0, sizeof(Loot) * nloots );

	posImpossible=impossibleStart;
	posNormal=0;

	if (p->credits > 0) {
		loots[posNormal].label = "Credits";

		loots[posNormal].type = LOOT_CREDITS;
		loots[posNormal].totalValue = p->credits;
		loots[posNormal].quantity = (int)p->credits;
		loots[posNormal].timeNeeded = ntime_create(0,0,0,0,10,0);
		loots[posNormal].ntexture = 1;
		loots[posNormal].textures = malloc(sizeof(glTexture));

		nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"credits.png");
		loots[posNormal].textures[0] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );

		posNormal++;
	}

	if (p->fuel > 0) {
		if (player.p->fuel >= player.p->fuel_max) {
			pos=posImpossible;
		} else {
			pos=posNormal;
		}

		loots[pos].label = "Fuel";

		loots[pos].type = LOOT_FUEL;
		loots[pos].fuel = (int)p->fuel;
		loots[pos].quantity = (int)p->fuel;
		loots[pos].timeNeeded = ntime_create(0,0,0,0,p->fuel/80,0);

		if (player.p->fuel >= player.p->fuel_max) {
			loots[pos].impossible = 1;

			loots[pos].ntexture = 2;
			loots[pos].textures = malloc(sizeof(glTexture) * 2);
			nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"fuel.png");
			loots[pos].textures[0] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );
			nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"barred.png");
			loots[pos].textures[1] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );

			posImpossible++;
		} else {
			loots[pos].ntexture = 1;
			loots[pos].textures = malloc(sizeof(glTexture));
			nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"fuel.png");
			loots[pos].textures[0] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );

			posNormal++;
		}
	}

	for (i=0;i<p->ncommodities;i++) {
		if (player.p->cargo_free == 0) {
			pos=posImpossible;
		} else {
			pos=posNormal;
		}

		loots[pos].label = p->commodities[i].commodity->name;

		loots[pos].type = LOOT_COMMODITTY;
		loots[pos].commodity = p->commodities[i].commodity;
		loots[pos].quantity = p->commodities[i].quantity;
		loots[pos].totalValue = p->commodities[i].quantity * p->commodities[i].commodity->price;
		loots[pos].timeNeeded = ntime_create(0,0,0,0,5+p->commodities[i].quantity/(crewSize*2),0);

		if (player.p->cargo_free == 0) {
			loots[pos].impossible = 1;
			loots[pos].ntexture = 2;
			loots[pos].textures = malloc(sizeof(glTexture) * 2);
			loots[pos].textures[0] = p->commodities[i].commodity->gfx_store;
			nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"barred.png");
			loots[pos].textures[1] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );

			posImpossible++;
		} else {
			loots[pos].ntexture = 1;
			loots[pos].textures = malloc(sizeof(glTexture));
			loots[pos].textures[0] = p->commodities[i].commodity->gfx_store;

			posNormal++;
		}
	}

	for (i=0;i<p->noutfits;i++) {

		if (p->outfits[i]->outfit != NULL) {
			loots[posNormal].label = p->outfits[i]->outfit->name;

			if (p->outfits[i]->outfit->slot.size == OUTFIT_SLOT_SIZE_LIGHT) {
				slotSize = 1;
			} else if (p->outfits[i]->outfit->slot.size == OUTFIT_SLOT_SIZE_MEDIUM) {
				slotSize = 2;
			} else if (p->outfits[i]->outfit->slot.size == OUTFIT_SLOT_SIZE_HEAVY) {
				slotSize = 4;
			} else {
				slotSize = 1;
			}

			loots[posNormal].type = LOOT_OUTFIT;
			loots[posNormal].outfit = p->outfits[i]->outfit;
			loots[posNormal].quantity = 1;
			loots[posNormal].timeNeeded = ntime_create(0,0,0,0,5+slotSize*50/crewSize,0);
			loots[posNormal].totalValue = p->outfits[i]->outfit->price;
			loots[posNormal].ntexture = p->outfits[i]->outfit->gfx_store_nlayers;
			loots[posNormal].textures = p->outfits[i]->outfit->gfx_store_layers;

			posNormal++;
		}
	}
}

/**
 * @brief displays a selected loot (in the info fields to the right of the window)
 */
static void board_displayLoot(unsigned int wid, const char *lootLabel) {
	int i;
	Loot loot;
	char buf[256],buf2[128],buf3[128];
	char *impossible;

	for (i=0;i<nloots;i++) {
		if (strcmp(loots[i].label,lootLabel) == 0) {
			loot=loots[i];
		}
	}

	window_modifyText( wid, "txtLootZoomTitle", loot.label );
	window_modifyImageLayered( wid, "imgLootZoom", loot.textures, loot.ntexture, 128, 128 );

	ntime_prettyBuf(buf2,128,loot.timeNeeded,1);

	credits2str( buf3, loot.totalValue, 2 );

	if (loot.impossible == 1 && loot.type == LOOT_FUEL) {
		impossible="\n\n\erYour fuel tanks are full.\e0";
	} else if (loot.impossible == 1 && loot.type == LOOT_COMMODITTY) {
		impossible="\n\n\erYour cargo space is full.\e0";
	} else {
		impossible="";
	}

	nsnprintf( buf, 256,
					"%d\n"
					"%s\n"
					"%s",
					loot.quantity,
					buf3,
					buf2
			);
	window_modifyText( wid, "txtLootZoomDesc", buf );

	window_modifyText( wid, "txtLootZoomImpossible", impossible );

}

/**
 * @brief updates the displayed loot after click in the main list
 */
void board_listUpdate( unsigned int wid, char* str ) {
	(void)str;
	char *lootLabel;
	lootLabel = toolkit_getImageLayeredArray( wid, "iarLoots" );

	if (lootLabel == NULL)
		return;

	board_displayLoot(wid,lootLabel);
}

/**
 * @brief updates the displayed loot after click in the selected list
 */
void board_listUpdateSelected( unsigned int wid, char* str ) {
	(void)str;
	char *lootLabel;
	lootLabel = toolkit_getImageLayeredArray( wid, "iarLootsSelected" );

	if (lootLabel == NULL)
		return;

	board_displayLoot(wid,lootLabel);
}

/**
 * @brief takes a loot item (moves it to the bottom list)
 */
void board_take( unsigned int wid, char* str ) {
	(void)str;
	int i, pos, selpos;
	selpos = toolkit_getImageLayeredArrayPos( wid, "iarLoots" );

	pos=0;
	for (i=0;i<nloots;i++) {
		if (loots[i].selected == 0 && loots[i].impossible == 0) {
			if (pos == selpos) {
				loots[i].selected = 1;
			}
			pos++;
		}
	}

	board_createLootLists(wid);
}

/**
 * @brief returns a loot item to the main list
 */
void board_remove( unsigned int wid, char* str ) {
	(void)str;
	int i, pos, selpos;
		selpos = toolkit_getImageLayeredArrayPos( wid, "iarLootsSelected" );

		pos=0;
		for (i=0;i<nloots;i++) {
			if (loots[i].selected == 1) {
				if (pos == selpos) {
					loots[i].selected = 0;
				}
				pos++;
			}
		}

	board_createLootLists(wid);
}

/**
 * @brief Forces unboarding of the pilot.
 */
void board_unboard (void)
{
   board_stopboard = 1;
}

/**
 * @brief starts the actual looting (window closes, looting process in-game starts)
 */
void board_startLoot( unsigned int wid, char* str ) {
	(void) str;
	int i,nChosenLoots,pos;
	Loot* chosenLoots;
	window_destroy( wid );

	nChosenLoots=0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 1) {
			nChosenLoots++;
		}
	}

	chosenLoots = malloc(sizeof(Loot) * nChosenLoots);
	pos = 0;
	for (i=0; i<nloots; i++) {
		if (loots[i].selected == 1) {
			memcpy ( &chosenLoots[pos], &loots[i], sizeof(Loot) );
			pos++;
		}
	}

	pilot_startLoot(player.p,pilot_get(player.p->target),chosenLoots,nChosenLoots);

	/* Is not boarded. */
	board_boarded = 0;
}

/**
 * @brief Closes the boarding window.
 *
 *    @param wid Window triggering the function.
 *    @param str Unused.
 */
void board_exit( unsigned int wid, char* str )
{
   (void) str;
   window_destroy( wid );

   free(loots);
   loots = NULL;

   /* Is not boarded. */
   board_boarded = 0;
}


/**
 * @brief Checks to see if the pilot can steal from its target.
 *
 *    @param p Pilot stealing from its target.
 *    @return 0 if successful, 1 if fails, -1 if fails and kills target.
 */
static int board_trySteal( Pilot *p )
{
   Pilot *target;
   Damage dmg;

   /* Get the target. */
   target = pilot_get(p->target);
   if (target == NULL)
      return 1;

   /* See if was successful. */
   if (RNGF() > (0.4 * (5. + target->crew*target->boarding_skills)/(5. + p->crew*p->boarding_skills)))
      return 0;

   /* Triggered self destruct. */
   if (RNGF() < 0.4) {
      /* Don't actually kill. */
      target->shield = 0.;
      target->armour = 1.;
      /* This will make the boarding ship take the possible faction hit. */
      dmg.type        = dtype_get("normal");
      dmg.damage      = 100.;
      dmg.penetration = 1.;
      dmg.disable     = 0.;
      pilot_hit( target, NULL, p->id, &dmg, 1 );
      /* Return ship dead. */
      return -1;
   }

   pilot_setFlag(target,PILOT_BOARDED_FAILED);

   return 1;
}


/**
 * @brief Checks to see if the hijack attempt failed.
 *
 *    @return 1 on failure to board, otherwise 0.
 */
static int board_fail(void)
{
   int ret;

   ret = board_trySteal( player.p );

   if (ret == 0)
      return 0;
   else if (ret < 0) /* killed ship. */
      player_message("\epYou have tripped the ship's self-destruct mechanism!");
   else /* you just got locked out */
      player_message("\epThe ship's security system locks %s out.",
            (player.p->ship->crew > 0) ? "your crew" : "you" );

   return 1;
}


/**
 * @brief Has a pilot attempt to board another pilot.
 *
 *    @param p Pilot doing the boarding.
 *    @return 1 if target was boarded.
 */
int pilot_board( Pilot *p )
{
   Pilot *target;
   HookParam hparam[2];

   /* Make sure target is sane. */
   target = pilot_get(p->target);
   if (target == NULL) {
      DEBUG("NO TARGET");
      return 0;
   }

   /* Check if can board. */
   if (!pilot_isDisabled(target))
      return 0;
   else if (vect_dist(&p->solid->pos, &target->solid->pos) >
         target->ship->gfx_space->sw * PILOT_SIZE_APROX )
      return 0;
   else if ((pow2(VX(p->solid->vel)-VX(target->solid->vel)) +
            pow2(VY(p->solid->vel)-VY(target->solid->vel))) >
            (double)pow2(MAX_HYPERSPACE_VEL))
      return 0;

   /* Set the boarding flag. */
   pilot_setFlag(target, PILOT_BOARDED_SUCCESS);
   pilot_setFlag(p, PILOT_BOARDING);

   /* Set time it takes to board. */
   p->ptimer = 3.;

   /* Run pilot board hook. */
   hparam[0].type       = HOOK_PARAM_PILOT;
   hparam[0].u.lp       = p->id;
   hparam[1].type       = HOOK_PARAM_SENTINEL;
   pilot_runHookParam(target, PILOT_HOOK_BOARDING, hparam, 1);
   hparam[0].u.lp       = target->id;
   pilot_runHookParam(target, PILOT_HOOK_BOARD, hparam, 1);

   return 1;
}


/**
 * @brief Finishes the boarding.
 *
 *    @param p Pilot to finish the boarding.
 */
void pilot_boardComplete( Pilot *p )
{
   int ret;
   Pilot *target;
   credits_t worth;
   char creds[ ECON_CRED_STRLEN ];

   /* Make sure target is sane. */
   target = pilot_get(p->target);
   if (target == NULL)
      return;

   /* In the case of the player take fewer credits. */
   if (pilot_isPlayer(target)) {
      worth = MIN( 0.1*pilot_worth(target), target->credits );
      p->credits       += worth;
      target->credits  -= worth;
      credits2str( creds, worth, 2 );
      player_message( "\e%c%s\e0 has plundered %s credits from your ship!",
            pilot_getFactionColourChar(p), p->name, creds );
   }
   else {
      /* Steal stuff, we only do credits for now. */
      ret = board_trySteal(p);
      if (ret == 0) {
         /* Normally just plunder it all. */
         p->credits += target->credits;
         target->credits = 0.;
      }
   }

   /* Finish the boarding. */
   pilot_rmFlag(p, PILOT_BOARDING);
}


