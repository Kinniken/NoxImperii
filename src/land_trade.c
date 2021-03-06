/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file land_trade.c
 *
 * @brief Handles the Trading Center at land.
 */


#include "land_trade.h"

#include "naev.h"
#include "ndata.h"

#include <stdlib.h>
#include <stdio.h>
#include "nstring.h"
#include <math.h>
#include <assert.h>
#include "log.h"
#include "hook.h"
#include "player.h"
#include "space.h"
#include "toolkit.h"
#include "tk/toolkit_priv.h"
#include "dialogue.h"
#include "map_find.h"
#include "land_shipyard.h"

/*
 * Quantity to buy on one click
*/
static int commodity_mod = 10;

static void commodity_regenQuantites( unsigned int wid );

/**
 * @brief Opens the local market window.
 */
void commodity_exchange_open( unsigned int wid )
{
	int i, ngoods;
	int* ntgoods;
	glTexture ***tgoods;
	char **goods, **quantity;
	int len, owned;
	int w, h;
	int iw, ih;
	char buf[PATH_MAX];

	/* Mark as generated. */
	land_tabGenerate(LAND_WINDOW_COMMODITY);

	/* Get window dimensions. */
	window_dimWindow( wid, &w, &h );

	/* Calculate image array dimensions. */
	/* Window size minus right column size minus space on left and right */
	iw = w-LAND_BUTTON_WIDTH-3*20;
	ih = h - 60;

	/* buttons */
	window_addButtonKey( wid, -20, 20,
			LAND_BUTTON_WIDTH, LAND_BUTTON_HEIGHT, "btnCommodityClose",
			"Take Off", land_buttonTakeoff, SDLK_t );
	window_addButtonKey( wid, -40-((LAND_BUTTON_WIDTH-20)/2), 20*2 + LAND_BUTTON_HEIGHT,
			(LAND_BUTTON_WIDTH-20)/2, LAND_BUTTON_HEIGHT, "btnCommodityBuy",
			"Buy", commodity_buy, SDLK_b );
	window_addButtonKey( wid, -20, 20*2 + LAND_BUTTON_HEIGHT,
			(LAND_BUTTON_WIDTH-20)/2, LAND_BUTTON_HEIGHT, "btnCommoditySell",
			"Sell", commodity_sell, SDLK_s );

	/* cust draws the modifier */
	window_addCust( wid, -40-((LAND_BUTTON_WIDTH-20)/2), 60+ 2*LAND_BUTTON_HEIGHT,
			(LAND_BUTTON_WIDTH-20)/2, LAND_BUTTON_HEIGHT, "cstMod", 0, commodity_renderMod, NULL, NULL );

	window_addText( wid, -20, -40, LAND_BUTTON_WIDTH, 120, 0,
			"txtName", &gl_defFont, &cBlack,
			"");

	/* store gfx */
	window_addRect( wid, 20+iw+20+(LAND_BUTTON_WIDTH-128)/2, -60,
			128, 128, "rctStore", &cBlack, 0 );
	window_addImage( wid, 20+iw+20+(LAND_BUTTON_WIDTH-128)/2, -60,
			128, 128, "imgStore", NULL, 1 );

	window_addText( wid, -20, -190, LAND_BUTTON_WIDTH, 20, 1,
			"txtPrice", &gl_smallFont, &cBlack,
			"");

	/* text */
	window_addText( wid, -20, -230, LAND_BUTTON_WIDTH, 120, 0,
			"txtSInfo", &gl_smallFont, &cDConsole,
			"You have:\n"
			"Buying Price:\n"
			"Buyable:\n"
			"Selling Price:\n"
			"Sellable:\n"
			"Free Space:\n" );
	window_addText( wid, -20, -230, LAND_BUTTON_WIDTH/2, 120, 0,
			"txtDInfo", &gl_smallFont, &cBlack, NULL );
	window_addText( wid, -40, -360, LAND_BUTTON_WIDTH-20,
			h-140-LAND_BUTTON_HEIGHT, 0,
			"txtDesc", &gl_smallFont, &cBlack, NULL );

	/* goods list */
	if (land_planet->ntradedatas > 0) {

		ngoods = land_planet->ntradedatas;
		goods = malloc(sizeof(char*) * ngoods);
		ntgoods = malloc(sizeof(int*)* ngoods);
		tgoods    = malloc(sizeof(glTexture**) * ngoods);
		quantity = malloc(sizeof(char*)*ngoods);

		for (i=0; i<ngoods; i++) {
			goods[i]=strdup(land_planet->tradedatas[i].commodity->name);

			ntgoods[i] = 3;
			tgoods[i] = malloc(sizeof(glTexture*) * 3);
			tgoods[i][0] = land_planet->tradedatas[i].commodity->gfx_store;

			if (land_planet->tradedatas[i].buyingQuantity>0 && land_planet->tradedatas[i].sellingQuantity>0) {
				nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"layers/buysell.png");
				tgoods[i][1] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );
			} else if (land_planet->tradedatas[i].buyingQuantity>0) {
				nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"layers/buy.png");
				tgoods[i][1] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );
			} else {
				nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"layers/sell.png");
				tgoods[i][1] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );
			}

			nsnprintf( buf, PATH_MAX, COMMODITY_GFX_PATH"layers/price_%d.png",commodity_price_level(land_planet->tradedatas[i].adjustedPriceFactor));
			tgoods[i][2] = gl_newImage( buf, OPENGL_TEX_MIPMAPS );

			/* Quantity. */
			owned = pilot_cargoOwned( player.p, goods[i] );
			len = owned / 10 + 4;
			if (owned >= 1) {
				quantity[i] = malloc( len );
				nsnprintf( quantity[i], len, "%d", owned );
			}
			else
				quantity[i] = NULL;
		}
	}
	else {
		goods    = malloc( sizeof(char*) );
		goods[0] = strdup("None");
		ntgoods = malloc(sizeof(int*));
		ntgoods[0] = 1;
		tgoods    = malloc(sizeof(glTexture**));
		tgoods[0] = malloc(sizeof(glTexture*));
		tgoods[0][0] = NULL;
		ngoods   = 1;
	}

	/* set up the goods to buy/sell */
	window_addImageLayeredArray( wid, 20, 20,
			iw, ih, "iarTrade", 128, 128,
			tgoods, ntgoods, goods, ngoods, commodity_update, commodity_update );

	if (land_planet->ntradedatas > 0) {
		toolkit_setImageLayeredArrayQuantity( wid, "iarTrade", quantity );
	}

	/* Set default keyboard focuse to the list */
	window_setFocus( wid , "iarTrade" );
}
/**
 * @brief Updates the commodity window.
 *    @param wid Window to update.
 *    @param str Unused.
 */
void commodity_update( unsigned int wid, char* str )
{
   (void)str;
   char buf[PATH_MAX];
   char *comname;
   Commodity *com;
   TradeData *tradeData;

   comname = toolkit_getImageLayeredArray( wid, "iarTrade" );
   if ((comname==NULL) || (strcmp( comname, "None" )==0)) {
      nsnprintf( buf, PATH_MAX,
         "NA Tonnes\n"
         "NA cr/t\n"
         "NA Tonnes\n");
      window_modifyText( wid, "txtDInfo", buf );
      window_modifyText( wid, "txtName", "None" );
      window_modifyText( wid, "txtPrice", "" );
      window_modifyText( wid, "txtDesc", "No commodities available." );
      window_disableButton( wid, "btnCommodityBuy" );
      window_disableButton( wid, "btnCommoditySell" );
      return;
   }
   com = commodity_get( comname );
   tradeData = planet_getTradeData(land_planet,com);

   window_modifyText( wid, "txtName", com->name );

   /* modify image */
   window_modifyImage( wid, "imgStore", com->gfx_store, 128, 128 );

   nsnprintf( buf, PATH_MAX,
   	         "Price level: %s",commodity_price_adj(tradeData->adjustedPriceFactor));

   window_modifyText( wid, "txtPrice", buf);

   /* modify text */
   if (tradeData->buyingQuantity==0) {//just selling
	   nsnprintf( buf, PATH_MAX,
	         "%d Tonnes\n"
	         "\n"
			 "None\n"
	         "%"CREDITS_PRI" cr/t\n"
	         "%d/%d t\n"
	         "%d Tonnes\n",
	         pilot_cargoOwned( player.p, comname ),
	         planet_commodityPriceSelling( land_planet, com ),
	         tradeData->sellingQuantityRemaining,
	         tradeData->sellingQuantity,
	         pilot_cargoFree(player.p));
   } else if (tradeData->sellingQuantity==0) {//just buying
	   nsnprintf( buf, PATH_MAX,
	   	         "%d Tonnes\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "%d/%d t\n"
	   	         "\n"
	   	         "None\n"
	   	         "%d Tonnes\n",
	   	         pilot_cargoOwned( player.p, comname ),
	   	         planet_commodityPriceBuying( land_planet, com ),
	   	         tradeData->buyingQuantityRemaining,
	   	         tradeData->buyingQuantity,
	   	         pilot_cargoFree(player.p));
   } else {//both
	   nsnprintf( buf, PATH_MAX,
	   	         "%d Tonnes\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "%d/%d t\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "%d/%d t\n"
	   	         "%d Tonnes\n",
	   	         pilot_cargoOwned( player.p, comname ),
	   	         planet_commodityPriceBuying( land_planet, com ),
	   	         tradeData->buyingQuantityRemaining,
	   	         tradeData->buyingQuantity,
	   	         planet_commodityPriceSelling( land_planet, com ),
	   	         tradeData->sellingQuantityRemaining,
	   	         tradeData->sellingQuantity,
	   	         pilot_cargoFree(player.p));
   }

   window_modifyText( wid, "txtDInfo", buf );
   window_modifyText( wid, "txtDesc", com->description );

   /* Button enabling/disabling */
   if (commodity_canBuy( comname ))
      window_enableButton( wid, "btnCommodityBuy" );
   else
      window_disableButtonSoft( wid, "btnCommodityBuy" );

   if (commodity_canSell( comname ))
      window_enableButton( wid, "btnCommoditySell" );
   else
      window_disableButtonSoft( wid, "btnCommoditySell" );

   /* regenerate quantities */
   commodity_regenQuantites(wid);
}


int commodity_canBuy( char *name )
{
   int failure;
   unsigned int q, price;
   Commodity *com;
   TradeData* tradeData;
   char buf[ECON_CRED_STRLEN];

   failure = 0;
   q = commodity_getMod();
   com = commodity_get( name );
   tradeData = planet_getTradeData(land_planet,com);
   price = planet_commodityPriceBuying( land_planet, com ) * q;

   if (!player_hasCredits( price )) {
      credits2str( buf, price - player.p->credits, 2 );
      land_errDialogueBuild("You need %s more credits.", buf );
      failure = 1;
   }
   if (pilot_cargoFree(player.p) <= 0) {
      land_errDialogueBuild("No cargo space available!");
      failure = 1;
   }
   if (tradeData->buyingQuantityRemaining<1) {
      land_errDialogueBuild("No goods available here!");
      failure = 1;
   }

   return !failure;
}


int commodity_canSell( char *name )
{
   int failure;
   Commodity *com;
   TradeData* tradeData;

   failure = 0;
   com = commodity_get( name );
   tradeData = planet_getTradeData(land_planet,com);

   if (pilot_cargoOwned( player.p, name ) == 0) {
      land_errDialogueBuild("You can't sell something you don't have!");
      failure = 1;
   }
   if (tradeData->sellingQuantityRemaining<1) {
      land_errDialogueBuild("No more buyers for this good!");
      failure = 1;
   }

   return !failure;
}


/**
 * @brief Buys the selected commodity.
 *    @param wid Window buying from.
 *    @param str Unused.
 */
void commodity_buy( unsigned int wid, char* str )
{
   (void)str;
   char *comname;
   Commodity *com;
   unsigned int q;
   credits_t price;
   HookParam hparam[3];
   TradeData* tradeData;

   /* Get selected. */
   q     = commodity_getMod();

   comname = toolkit_getImageLayeredArray( wid, "iarTrade" );

   com   = commodity_get( comname );
   tradeData = planet_getTradeData(land_planet,com);
   price = planet_commodityPriceBuying( land_planet, com );

   if (q> (unsigned int)(tradeData->buyingQuantityRemaining)) {
	   q=tradeData->buyingQuantityRemaining;
   }

   /* Check stuff. */
   if (land_errDialogue( comname, "buyCommodity" ))
      return;

   /* Make the buy. */
   q = pilot_cargoAdd( player.p, com, q, 0 );
   tradeData->buyingQuantityRemaining-=q;
   tradeData->sellingQuantityRemaining+=q;

   if (tradeData->sellingQuantityRemaining>tradeData->sellingQuantity) {
	   tradeData->sellingQuantityRemaining=tradeData->sellingQuantity;
   }


   price *= q;
   player_modCredits( -price );
   commodity_update(wid, NULL);

   /* Run hooks. */
   hparam[0].type    = HOOK_PARAM_STRING;
   hparam[0].u.str   = comname;
   hparam[1].type    = HOOK_PARAM_NUMBER;
   hparam[1].u.num   = q;
   hparam[2].type    = HOOK_PARAM_SENTINEL;
   hooks_runParam( "comm_buy", hparam );
   if (land_takeoff)
      takeoff(1);
}
/**
 * @brief Attempts to sell a commodity.
 *    @param wid Window selling commodity from.
 *    @param str Unused.
 */
void commodity_sell( unsigned int wid, char* str )
{
   (void)str;
   char *comname;
   Commodity *com;
   unsigned int q;
   credits_t price;
   HookParam hparam[3];
   TradeData* tradeData;

   /* Get parameters. */
   q     = commodity_getMod();
   comname = toolkit_getImageLayeredArray( wid, "iarTrade" );

   com   = commodity_get( comname );
   tradeData = planet_getTradeData(land_planet,com);
   price = planet_commodityPriceSelling( land_planet, com );

   if (q> (unsigned int)(tradeData->sellingQuantityRemaining)) {
	   q=tradeData->sellingQuantityRemaining;
   }

   /* Check stuff. */
   if (land_errDialogue( comname, "sellCommodity" ))
      return;

   /* Remove commodity. */
   q = pilot_cargoRm( player.p, com, q );
   tradeData->sellingQuantityRemaining-=q;
   tradeData->buyingQuantityRemaining+=q;

   if (tradeData->buyingQuantityRemaining>tradeData->buyingQuantity) {
	   tradeData->buyingQuantityRemaining=tradeData->buyingQuantity;
   }

   price = price * (credits_t)q;
   player_modCredits( price );
   commodity_update(wid, NULL);

   /* Run hooks. */
   hparam[0].type    = HOOK_PARAM_STRING;
   hparam[0].u.str   = comname;
   hparam[1].type    = HOOK_PARAM_NUMBER;
   hparam[1].u.num   = q;
   hparam[2].type    = HOOK_PARAM_SENTINEL;
   hooks_runParam( "comm_sell", hparam );
   if (land_takeoff)
      takeoff(1);
}

/**
 * @brief Gets the current modifier status.
 *    @return The amount modifier when buying or selling commodities.
 */
int commodity_getMod (void)
{
   SDLMod mods;
   int q;

   mods = SDL_GetModState();
   q = 10;
   if (mods & (KMOD_LCTRL | KMOD_RCTRL))
      q *= 5;
   if (mods & (KMOD_LSHIFT | KMOD_RSHIFT))
      q *= 10;

   return q;
}
/**
 * @brief Renders the commodity buying modifier.
 *    @param bx Base X position to render at.
 *    @param by Base Y position to render at.
 *    @param w Width to render at.
 *    @param h Height to render at.
 */
void commodity_renderMod( double bx, double by, double w, double h, void *data )
{
   (void) data;
   (void) h;
   int q;
   char buf[8];

   q = commodity_getMod();
   if (q != commodity_mod) {
      commodity_update( land_getWid(LAND_WINDOW_COMMODITY), NULL );
      commodity_mod = q;
   }
   nsnprintf( buf, 8, "%dx", q );
   gl_printMid( &gl_smallFont, w, bx, by, &cBlack, buf );
}

static void commodity_regenQuantites( unsigned int wid )
{
	if (land_planet->ntradedatas == 0) {
		return;
	}

	int i, ngoods;

	char **quantity;
	int len, owned;

	ngoods = land_planet->ntradedatas;
	quantity = malloc(sizeof(char*)*ngoods);

	for (i=0; i<ngoods; i++) {

		/* Quantity. */
		owned = pilot_cargoOwned( player.p, land_planet->tradedatas[i].commodity->name );
		len = owned / 10 + 4;
		if (owned >= 1) {
			quantity[i] = malloc( len );
			nsnprintf( quantity[i], len, "%d", owned );
		}
		else
			quantity[i] = NULL;
	}

	toolkit_setImageLayeredArrayQuantity( wid, "iarTrade", quantity );
}
