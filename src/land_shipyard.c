/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file land_shipyard.c
 *
 * @brief Handles the shipyard at land.
 */


#include "land_shipyard.h"

#include "naev.h"

#include <stdlib.h>
#include <stdio.h>
#include "nstring.h"
#include <math.h>
#include <assert.h>
#include "log.h"
#include "player.h"
#include "space.h"
#include "toolkit.h"
#include "tk/toolkit_priv.h"
#include "dialogue.h"
#include "map_find.h"
#include "slots.h"
#include "ndata.h"

#define DESC_MAX         512

/*
 * Vars.
 */
static Ship* shipyard_selected = NULL; /**< Currently selected shipyard ship. */
static Pilot* shipyard_pilot = NULL; /** Pilot for the currently select ship (for the spinning graphics) **/
static double shipyard_dir      = 0.; /**< Equipment dir. */
static unsigned int shipyard_lastick = 0; /**< Last tick. */

/*
 * Helper functions.
 */
static void shipyard_buy( unsigned int wid, char* str );
static void shipyard_trade( unsigned int wid, char* str );
static void shipyard_rmouse( unsigned int wid, char* widget_name );
static void shipyard_renderSlots( double bx, double by, double bw, double bh, void *data );
static void shipyard_renderSlotsRow( double bx, double by, double bw, char *str, ShipOutfitSlot *s, int n );
static void shipyard_renderShip( double bx, double by, double bw, double bh, void *data );
static void shipyard_find( unsigned int wid, char* str );
static const char *shipyard_slotSize( const OutfitSlotSize* size );
static int shipyard_generateSlotDesc(int bx, int yStart, int nslots, ShipOutfitSlot *slots, const char *typeName);

/**
 * @brief Opens the shipyard window.
 */
void shipyard_open( unsigned int wid )
{
   int i;
   Ship **ships;
   char **sships;
   glTexture ***tships;
   int *ntships;
   int nships;
   int w, h;
   int iw, ih;
   int bw, bh, padding, off;
   int th;
   int y;
   const char *buf;

   /* Mark as generated. */
   land_tabGenerate(LAND_WINDOW_SHIPYARD);

   /* Init vars. */
   shipyard_selected = NULL;

   /* Get window dimensions. */
   window_dimWindow( wid, &w, &h );

   /* Calculate image array dimensions. */
   iw = 310 + (w-800);
   ih = h - 60;

   /* Left padding + per-button padding * nbuttons */
   padding = 40 + 20 * 4;

   /* Calculate button dimensions. */
   bw = (w - iw - padding) / 4;
   bh = LAND_BUTTON_HEIGHT;

   /* buttons */
   window_addButtonKey( wid, off = -20, 20,
         bw, bh, "btnCloseShipyard",
         "Take Off", land_buttonTakeoff, SDLK_t );
   window_addButtonKey( wid, off -= 20+bw, 20,
         bw, bh, "btnTradeShip",
         "Trade-In", shipyard_trade, SDLK_r );
   window_addButtonKey( wid, off -= 20+bw, 20,
         bw, bh, "btnBuyShip",
         "Buy", shipyard_buy, SDLK_b );
   window_addButtonKey( wid, off -= 20+bw, 20,
         bw, bh, "btnFindShips",
         "Find Ships", shipyard_find, SDLK_f );

   window_addCust( wid, -40, -50, SHIP_TARGET_W, SHIP_TARGET_H, "cstTarget", 0,
		   shipyard_renderShip, NULL, NULL );

   window_addText( wid, -40, -192, 128, 200, 0, "txtLMilitary",
               &gl_smallFont, &cBlack, "Military:" );

   window_addImage( wid, -40, -194, 58, 10, "imgMilitary", NULL, 0 );

   window_addText( wid, -40, -208, 128, 200, 0, "txtLUtility",
                  &gl_smallFont, &cBlack, "Utility:" );

   window_addImage( wid, -40, -210, 58, 10, "imgUtility", NULL, 0 );

   window_addText( wid, -40, -224, 128, 200, 0, "txtLAgility",
                  &gl_smallFont, &cBlack, "Agility:" );

   window_addImage( wid, -40, -226, 58, 10, "imgAgility", NULL, 0 );


   /* slot types */
   window_addCust( wid, -40, -246, 128, 200, "cstSlots", 0.,
         shipyard_renderSlots, NULL, NULL );


   window_addText( wid, -40, -450, 128, 200, 0, "txtLStats",
            &gl_smallFont, &cBlack, "Bonus stats:" );

   /* stat text */
   window_addText( wid, -40, -470, 128, 200, 0, "txtStats",
         &gl_smallFont, &cBlack, NULL );

   /* text */
   buf = "Model:\n"
         "Class:\n"
         "Fabricator:\n"
         "Crew:\n"
         "\n"
         "CPU:\n"
         "Mass:\n"
         "Thrust:\n"
         "Speed:\n"
         "Turn:\n"
         "\n"
         "Absorption:\n"
         "Shield:\n"
         "Armour:\n"
         "Energy:\n"
         "Cargo Space:\n"
		 "Fuel Use:\n"
         "Fuel:\n"
         "Price:\n"
         "Money:\n"
         "License:\n";
   th = gl_printHeightRaw( &gl_smallFont, 100, buf );
   y  = -55;
   window_addText( wid, 40+iw+20, y,
         100, th, 0, "txtSDesc", &gl_smallFont, &cDConsole, buf );
   window_addText( wid, 40+iw+20+100, y,
         w-(40+iw+20+100)-20, th, 0, "txtDDesc", &gl_smallFont, &cBlack, NULL );
   y -= th;
   window_addText( wid, 20+iw+40, y,
         w-(20+iw+40) - 180, 250, 0, "txtDescription",
         &gl_smallFont, NULL, NULL );

   /* set up the ships to buy/sell */
   ships = tech_getShip( land_planet->tech, &nships );
   if (nships <= 0) {
      sships    = malloc(sizeof(char*));
      sships[0] = strdup("None");
      tships    = malloc(sizeof(glTexture**));
      tships[0] = malloc( sizeof(glTexture*) );
      tships[0][0] = NULL;
      ntships = malloc(sizeof(int) );
      ntships[0] = 0;
      nships    = 1;
   }
   else {
      sships = malloc(sizeof(char*)*nships);
      tships = malloc(sizeof(glTexture**)*nships);
      ntships = malloc(sizeof(int)*nships);
      for (i=0; i<nships; i++) {
         sships[i] = strdup(ships[i]->name);

         tships[i] = ships[i]->gfx_store_layers;
         ntships[i] = ships[i]->gfx_store_nlayers;
      }
      free(ships);
   }
   window_addImageLayeredArray( wid, 20, 20,
         iw, ih, "iarShipyard", 96., 96.,
         tships, ntships, sships, nships, shipyard_update, shipyard_rmouse );

   /* write the shipyard stuff */
   shipyard_update(wid, NULL);
   /* Set default keyboard focuse to the list */
   window_setFocus( wid , "iarShipyard" );
}
/**
 * @brief Updates the ships in the shipyard window.
 *    @param wid Window to update the ships in.
 *    @param str Unused.
 */
void shipyard_update( unsigned int wid, char* str )
{
   (void)str;
   char *shipname, *license_text;
   Ship* ship;
   char buf[DESC_MAX], buf2[ECON_CRED_STRLEN], buf3[ECON_CRED_STRLEN];
   size_t len;
   double jumps=0;
   Vector2d vp, vv;
   PilotFlags flags;

   shipname = toolkit_getImageLayeredArray( wid, "iarShipyard" );

   /* No ships */
   if (strcmp(shipname,"None")==0) {
      window_modifyImage( wid, "imgTarget", NULL, 0, 0 );
      window_disableButton( wid, "btnBuyShip");
      window_disableButton( wid, "btnTradeShip");
      nsnprintf( buf, DESC_MAX,
            "None\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n"
            "NA\n" );
      window_modifyImage( wid, "imgTarget", NULL, 0, 0 );
      window_modifyText( wid, "txtStats", NULL );
      window_modifyText( wid, "txtDescription", NULL );
      window_modifyText( wid, "txtDDesc", buf );
      return;
   }

   ship = ship_get( shipname );
   shipyard_selected = ship;

   vect_cset( &vp, 0., 0. );
   vect_cset( &vv, 0., 0. );
   pilot_clearFlagsRaw( flags );

   if (shipyard_pilot != NULL ) {
	   free(shipyard_pilot);
   }

   shipyard_pilot = pilot_createEmpty( ship, "", faction_get("Player"), NULL, flags);

   /* update text */
   if (ship->desc_stats == NULL)
	   window_modifyText( wid, "txtStats", "None" );
   else
	   window_modifyText( wid, "txtStats", ship->desc_stats );

   window_modifyText( wid, "txtDescription", ship->description );
   price2str( buf2, ship_buyPrice(ship), player.p->credits, 2 );
   credits2str( buf3, player.p->credits, 2 );

   /* Remove the word " License".  It's redundant and makes the text overflow
      into another text box */
   license_text = ship->license;
   if (license_text) {
      len = strlen(ship->license);
      if (strcmp(" License", ship->license + len - 8) == 0) {
		  license_text = malloc(len - 7);
		  assert(license_text);
		  memcpy(license_text, ship->license, len - 8);
		  license_text[len - 8] = '\0';
	   }
   }

   //need to avoid a /0 if fuel consumption isn't filled
   if (ship->fuel_consumption>0 && ship->fuel>0)
	   jumps=(ship->fuel/ship->fuel_consumption);

   nsnprintf( buf, DESC_MAX,
         "%s\n"
         "%s\n"
         "%s\n"
         "%d\n"
         "\n"
         "%.0f teraflops\n"
         "%.0f tonnes\n"
         "%.0f kN/tonne\n"
         "%.0f m/s\n"
         "%.0f deg/s\n"
         "\n"
         "%.0f%% damage\n"
         "%.0f MJ (%.1f MW)\n"
         "%.0f MJ (%.1f MW)\n"
         "%.0f MJ (%.1f MW)\n"
         "%.0f tonnes\n"
         "%.0f units\n"
		 "%d units (%.0f jumps)\n"
         "%s credits\n"
         "%s credits\n"
         "%s\n",
         ship->name,
         ship_class(ship),
         ship->fabricator,
         ship->crew,
         /* Weapons & Manoeuvrability */
         ship->cpu,
         ship->mass,
         ship->thrust,
         ship->speed,
         ship->turn*180/M_PI,
         /* Misc */
         ship->dmg_absorb*100.,
         ship->shield, ship->shield_regen,
         ship->armour, ship->armour_regen,
         ship->energy, ship->energy_regen,
         ship->cap_cargo,
		 ship->fuel_consumption,
         ship->fuel,
		 jumps,
         buf2,
         buf3,
         (license_text != NULL) ? license_text : "None" );
   window_modifyText( wid,  "txtDDesc", buf );

   if (license_text != ship->license)
      free(license_text);

   if (ship->rating_military > 0) {
	   nsnprintf( buf, PATH_MAX, SHIP_GFX_PATH"layers/rating_%d.png", ship->rating_military);
	   window_modifyImage( wid, "imgMilitary", gl_newImage( buf, OPENGL_TEX_MIPMAPS ), 0, 0 );

	   nsnprintf( buf, PATH_MAX, SHIP_GFX_PATH"layers/rating_%d.png", ship->rating_utility);
	   window_modifyImage( wid, "imgUtility", gl_newImage( buf, OPENGL_TEX_MIPMAPS ), 0, 0 );

	   nsnprintf( buf, PATH_MAX, SHIP_GFX_PATH"layers/rating_%d.png", ship->rating_agility);
	   window_modifyImage( wid, "imgAgility", gl_newImage( buf, OPENGL_TEX_MIPMAPS ), 0, 0 );

   }


   if (!shipyard_canBuy( shipname, land_planet ))
      window_disableButtonSoft( wid, "btnBuyShip");
   else
      window_enableButton( wid, "btnBuyShip");

   if (!shipyard_canTrade( shipname ))
      window_disableButtonSoft( wid, "btnTradeShip");
   else
      window_enableButton( wid, "btnTradeShip");
}


/**
 * @brief Starts the map find with ship search selected.
 *    @param wid Window buying outfit from.
 *    @param str Unused.
 */
static void shipyard_find( unsigned int wid, char* str )
{
   (void) str;
   map_inputFindType(wid, "ship");
}


/**
 * @brief Player right-clicks on a ship.
 *    @param wid Window player is buying ship from.
 *    @param widget_name Name of the window. (unused)
 *    @param shipname Name of the ship the player wants to buy. (unused)
 */
static void shipyard_rmouse( unsigned int wid, char* widget_name )
{
    return shipyard_buy(wid, widget_name);
}


/**
 * @brief Player attempts to buy a ship.
 *    @param wid Window player is buying ship from.
 *    @param str Unused.
 */
static void shipyard_buy( unsigned int wid, char* str )
{
   (void)str;
   char *shipname, buf[ECON_CRED_STRLEN];
   Ship* ship;

   shipname = toolkit_getImageLayeredArray( wid, "iarShipyard" );
   if (strcmp(shipname, "None") == 0)
      return;

   ship = ship_get( shipname );

   credits_t targetprice = ship_buyPrice(ship);

   if (land_errDialogue( shipname, "buyShip" ))
      return;

   credits2str( buf, targetprice, 2 );
   if (dialogue_YesNo("Are you sure?", /* confirm */
         "Do you really want to spend %s on a new ship?", buf )==0)
      return;

   /* player just got a new ship */
   if (player_newShip( ship, NULL, 0, 0 ) == NULL) {
      /* Player actually aborted naming process. */
      return;
   }
   player_modCredits( -targetprice ); /* ouch, paying is hard */

   /* Update shipyard. */
   shipyard_update(wid, NULL);
}

/**
 * @brief Makes sure it's sane to buy a ship.
 *    @param shipname Ship being bought.
 */
int shipyard_canBuy ( char *shipname, Planet *planet )
{
   Ship* ship;
   ship = ship_get( shipname );
   int failure = 0;
   credits_t price;

   price = ship_buyPrice(ship);

   /* Must have enough credits and the necessary license. */
   if ((!player_hasLicense(ship->license)) &&
         ((planet == NULL) || (!planet_isBlackMarket(planet)))) {
      land_errDialogueBuild( "You lack the %s.", ship->license );
      failure = 1;
   }
   if (!player_hasCredits( price )) {
      char buf[ECON_CRED_STRLEN];
      credits2str( buf, price - player.p->credits, 2 );
      land_errDialogueBuild( "You need %s more credits.", buf);
      failure = 1;
   }
   return !failure;
}

/**
 * @brief Makes sure it's sane to sell a ship.
 *    @param shipname Ship being sold.
 */
int can_sell( char* shipname )
{
   int failure = 0;
   if (strcmp( shipname, player.p->name )==0) { /* Already on-board. */
      land_errDialogueBuild( "You can't sell the ship you're piloting!", shipname );
      failure = 1;
   }

   return !failure;
}

/**
 * @brief Makes sure it's sane to change ships.
 *    @param shipname Ship being changed to.
 */
int can_swap( char* shipname )
{
   int failure = 0;
   Ship* ship;
   ship = ship_get( shipname );

   if (pilot_cargoUsed(player.p) > ship->cap_cargo) { /* Current ship has too much cargo. */
      land_errDialogueBuild( "You have %g tonnes more cargo than the new ship can hold.",
            pilot_cargoUsed(player.p) - ship->cap_cargo, ship->name );
      failure = 1;
   }
   if (pilot_hasDeployed(player.p)) { /* Escorts are in space. */
      land_errDialogueBuild( "You can't strand your fighters in space.");
      failure = 1;
   }
   return !failure;
}


/**
 * @brief Makes sure it's sane to buy a ship, trading the old one in simultaneously.
 *    @param shipname Ship being bought.
 */
int shipyard_canTrade( char* shipname )
{
   int failure = 0;
   Ship* ship;
   ship = ship_get( shipname );
   credits_t price;

   price = ship_buyPrice( ship );

   /* Must have the necessary license, enough credits, and be able to swap ships. */
   if (!player_hasLicense(ship->license)) {
      land_errDialogueBuild( "You lack the %s.", ship->license );
      failure = 1;
   }
   if (!player_hasCredits( price - player_shipPrice(player.p->name))) {
      credits_t creditdifference = price - (player_shipPrice(player.p->name) + player.p->credits);
      char buf[ECON_CRED_STRLEN];
      credits2str( buf, creditdifference, 2 );
      land_errDialogueBuild( "You need %s more credits.", buf);
      failure = 1;
   }
   if (!can_swap( shipname ))
      failure = 1;
   return !failure;
}


/**
 * @brief Player attempts to buy a ship, trading the current ship in.
 *    @param wid Window player is buying ship from.
 *    @param str Unused.
 */
static void shipyard_trade( unsigned int wid, char* str )
{
   (void)str;
   char *shipname, buf[ECON_CRED_STRLEN], buf2[ECON_CRED_STRLEN],
         buf3[ECON_CRED_STRLEN], buf4[ECON_CRED_STRLEN];
   Ship* ship;

   shipname = toolkit_getImageLayeredArray( wid, "iarShipyard" );
   if (strcmp(shipname, "None") == 0)
      return;

   ship = ship_get( shipname );

   credits_t targetprice = ship_buyPrice(ship);
   credits_t playerprice = player_shipPrice(player.p->name);

   if (land_errDialogue( shipname, "tradeShip" ))
      return;

   credits2str( buf, targetprice, 2 );
   credits2str( buf2, playerprice, 2 );
   credits2str( buf3, targetprice - playerprice, 2 );
   credits2str( buf4, playerprice - targetprice, 2 );

   /* Display the correct dialogue depending on the new ship's price versus the player's. */
   if ( targetprice == playerprice ) {
      if (dialogue_YesNo("Are you sure?", /* confirm */
         "Your %s is worth %s, exactly as much as the new ship, so no credits need be exchanged. Are you sure you want to trade your ship in?",
               player.p->ship->name, buf2)==0)
         return;
   }
   else if ( targetprice < playerprice ) {
      if (dialogue_YesNo("Are you sure?", /* confirm */
         "Your %s is worth %s credits, more than the new ship. For your ship, you will get the new %s and %s credits. Are you sure you want to trade your ship in?",
               player.p->ship->name, buf2, ship->name, buf4)==0)
         return;
   }
   else if ( targetprice > playerprice ) {
      if (dialogue_YesNo("Are you sure?", /* confirm */
         "Your %s is worth %s, so the new ship will cost %s credits. Are you sure you want to trade your ship in?",
               player.p->ship->name, buf2, buf3)==0)
         return;
   }

   /* player just got a new ship */
   if (player_newShip( ship, NULL, 1, 0 ) == NULL)
      return; /* Player aborted the naming process. */

   player_modCredits( playerprice - targetprice ); /* Modify credits by the difference between ship values. */

   land_refuel();

   /* The newShip call will trigger a loadGUI that will recreate the land windows. Therefore the land ID will
    * be void. We must reload in in order to properly update it again.*/
   wid = land_getWid(LAND_WINDOW_SHIPYARD);

   /* Update shipyard. */
   shipyard_update(wid, NULL);
}


/**
 * @brief Custom widget render function for the slot widget.
 */
static void shipyard_renderSlots( double bx, double by, double bw, double bh, void *data )
{
   (void) data;
   double x, y, w;
   Ship *ship;

   /* Make sure a valid ship is selected. */
   ship = shipyard_selected;
   if (ship == NULL)
      return;

   y = by + bh;

   /* Draw rotated text. */
   y -= 10;
   gl_print( &gl_smallFont, bx, y, &cBlack, "Slots:" );

   w = bw - 10.;
   x = bx;

   /* Weapon slots. */
   y -= 20;
   shipyard_renderSlotsRow( x, y, w, "W", ship->outfit_weapon, ship->outfit_nweapon );

   /* Utility slots. */
   y -= 20;
   shipyard_renderSlotsRow( x, y, w, "U", ship->outfit_utility, ship->outfit_nutility );

   /* Structure slots. */
   y -= 20;
   shipyard_renderSlotsRow( x, y, w, "S", ship->outfit_structure, ship->outfit_nstructure );

   y = shipyard_generateSlotDesc(bx,y,ship->outfit_nweapon,ship->outfit_weapon,"Weapon");

   y = shipyard_generateSlotDesc(bx,y,ship->outfit_nutility,ship->outfit_utility,"Utility");

   y = shipyard_generateSlotDesc(bx,y,ship->outfit_nstructure,ship->outfit_structure,"Structure");
}

int shipyard_generateSlotDesc(int bx, int yStart, int nslots, ShipOutfitSlot *slots, const char *typeName) {
	int i;
	int nb=0;
	unsigned int type=-1;
	int y=yStart;
	OutfitSlotSize size=OUTFIT_SLOT_SIZE_NA;

	for (i=0;i<nslots;i++) {
		if (slots[i].slot.size != size || slots[i].slot.spid != type) {
			if (nb>0) {
				y -= 20;
				if (type==0)
					gl_print( &gl_smallFont, bx, y, &cBlack, "%d %s %s", nb, shipyard_slotSize(&size), typeName );
				else
					gl_print( &gl_smallFont, bx, y, &cBlack, "%d %s %s",nb, shipyard_slotSize(&size), sp_display(type) );
			}
			type=slots[i].slot.spid;
			size=slots[i].slot.size;
			nb=0;
		}
		nb++;
	}
	if (nb>0) {
		y -= 20;
		if (type==0)
			gl_print( &gl_smallFont, bx, y, &cBlack, "%d %s %s", nb, shipyard_slotSize(&size), typeName );
		else
			gl_print( &gl_smallFont, bx, y, &cBlack, "%d %s %s",nb, shipyard_slotSize(&size), sp_display(type) );
	}

	return y;
}

const char *shipyard_slotSize( const OutfitSlotSize* size )
{
   switch(*size) {
      case OUTFIT_SLOT_SIZE_NA:
         return "NA";
      case OUTFIT_SLOT_SIZE_LIGHT:
         return "Small";
      case OUTFIT_SLOT_SIZE_MEDIUM:
         return "Medium";
      case OUTFIT_SLOT_SIZE_HEAVY:
         return "Large";
      default:
         return "Unknown";
   }
}


/**
 * @brief Renders a row of ship slots.
 */
static void shipyard_renderSlotsRow( double bx, double by, double bw, char *str, ShipOutfitSlot *s, int n )
{
   (void) bw;
   int i;
   double x;
   const glColour *c;

   x = bx;

   /* Print text. */
   gl_print( &gl_smallFont, bx, by, &cBlack, str );

   /* Draw squares. */
   for (i=0; i<n; i++) {
      c = outfit_slotSizeColour( &s[i].slot );
      if (c == NULL)
         c = &cBlack;

      x += 15.;
      toolkit_drawRect( x, by, 10, 10, c, NULL );
   }
}


static void shipyard_renderShip( double bx, double by, double bw, double bh, void *data )
{
	(void)data;
   int sx, sy;
   const glColour *lc, *c, *dc;
   unsigned int tick;
   double dt;
   double pw, ph;
   double w, h;
   double px, py;

   if (shipyard_pilot == NULL)
	   return;

   tick = SDL_GetTicks();
   dt   = (double)(tick - shipyard_lastick)/1000.;
   shipyard_lastick = tick;
   shipyard_dir += shipyard_pilot->turn * dt;
   if (shipyard_dir > 2*M_PI)
	   shipyard_dir = fmod( shipyard_dir, 2*M_PI );
   gl_getSpriteFromDir( &sx, &sy, shipyard_pilot->ship->gfx_space, shipyard_dir );

   /* Render ship graphic. */
   if (shipyard_pilot->ship->gfx_space->sw > bw) {
      pw = bw;
      ph = bh;
   }
   else {
      pw = shipyard_pilot->ship->gfx_space->sw;
      ph = shipyard_pilot->ship->gfx_space->sh;
   }
   w  = bw;
   h  = bh;
   px = bx + bw - 30 - w + (w-pw)/2 + 30;
   py = by + bh - 30 - h + (h-ph)/2 + 30;

   toolkit_drawRect( bx-5, by-5, w+10, h+10, &cBlack, NULL );
   gl_blitScaleSprite( shipyard_pilot->ship->gfx_space,
         px, py, sx, sy, pw, ph, NULL );

   lc = toolkit_colLight;
   c  = toolkit_col;
   dc = toolkit_colDark;
   toolkit_drawOutline( bx - 4., by-4., w+7., h+2., 1., lc, c  );
   toolkit_drawOutline( bx - 4., by-4., w+7., h+2., 2., dc, NULL  );
}


