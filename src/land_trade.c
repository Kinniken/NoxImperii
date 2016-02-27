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

/*
 * List of trade goods (actual names, not with B/S tags)
 */
static int ngoods;
static char **goods;


/**
 * @brief Opens the local market window.
 */
void commodity_exchange_open( unsigned int wid )
{
   int i;
   char **goodsLabel;
   int w, h;

   /* Get window dimensions. */
   window_dimWindow( wid, &w, &h );

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

   /* text */
   window_addText( wid, -20, -40, LAND_BUTTON_WIDTH, 120, 0,
         "txtSInfo", &gl_smallFont, &cDConsole,
         "You have:\n"
         "Buying Price:\n"
         "\n"
         "Buyable:\n"
         "Selling Price:\n"
         "\n"
         "Sellable:\n"
         "Free Space:\n" );
   window_addText( wid, -20, -40, LAND_BUTTON_WIDTH/2, 120, 0,
         "txtDInfo", &gl_smallFont, &cBlack, NULL );
   window_addText( wid, -40, -180, LAND_BUTTON_WIDTH-20,
         h-140-LAND_BUTTON_HEIGHT, 0,
         "txtDesc", &gl_smallFont, &cBlack, NULL );

   /* goods list */
   if (land_planet->ntradedatas > 0) {

	   if (goods!=NULL) {
		   free(goods);
	   }

      goods = malloc(sizeof(char*) * land_planet->ntradedatas);
      goodsLabel = malloc(sizeof(char*) * land_planet->ntradedatas);
      for (i=0; i<land_planet->ntradedatas; i++) {
    	  char str[strlen(land_planet->tradedatas[i].commodity->name)+10];
    	  strcpy (str,land_planet->tradedatas[i].commodity->name);
    	  if (land_planet->tradedatas[i].buyingQuantity==0) {
    		  strcat(str," (Selling only)");
    	  } else  if (land_planet->tradedatas[i].sellingQuantity==0) {
    		  strcat(str," (Buying only)");
    	  }
    	  goodsLabel[i]=strdup(str);
    	  goods[i]=strdup(land_planet->tradedatas[i].commodity->name);
      }

      ngoods = land_planet->ntradedatas;
   }
   else {
	   goods    = malloc( sizeof(char*) );
	   goods[0] = strdup("None");
	  goodsLabel    = malloc( sizeof(char*) );
	  goodsLabel[0] = strdup("None");
      ngoods   = 1;
   }
   window_addList( wid, 20, -40,
         w-LAND_BUTTON_WIDTH-60, h-80-LAND_BUTTON_HEIGHT,
         "lstGoods", goodsLabel, ngoods, 0, commodity_update );
   /* Set default keyboard focuse to the list */
   window_setFocus( wid , "lstGoods" );
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

   int pos= toolkit_getListPos(wid, "lstGoods" );
   if (pos==-1) {
	   comname=NULL;
   } else {
	   comname=goods[pos];
   }
   if ((comname==NULL) || (strcmp( comname, "None" )==0)) {
      nsnprintf( buf, PATH_MAX,
         "NA Tons\n"
         "NA Credits/Ton\n"
         "\n"
         "NA Tons\n" );
      window_modifyText( wid, "txtDInfo", buf );
      window_modifyText( wid, "txtDesc", "No commodities available." );
      window_disableButton( wid, "btnCommodityBuy" );
      window_disableButton( wid, "btnCommoditySell" );
      return;
   }
   com = commodity_get( comname );
   tradeData = planet_getTradeData(land_planet,com);

   /* modify text */
   if (tradeData->buyingQuantity==0) {//just selling
	   nsnprintf( buf, PATH_MAX,
	         "%d Tons\n"
	         "\n"
	         "\n"
			 "\n"
	         "%"CREDITS_PRI" cr/t\n"
	         "(%+g%%)\n"
	         "%d/%d t\n"
	         "\n"
	         "%d Tons\n",
	         pilot_cargoOwned( player.p, comname ),
	         planet_commodityPriceSelling( land_planet, com ),
	         round((planet_commodityPriceSellingRatio( land_planet, com)-1.0)*100),
	         tradeData->sellingQuantityRemaining,
	         tradeData->sellingQuantity,
	         pilot_cargoFree(player.p));
   } else if (tradeData->sellingQuantity==0) {//just buying
	   nsnprintf( buf, PATH_MAX,
	   	         "%d Tons\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "(%+g%%)\n"
	   	         "%d/%d t\n"
	   	         "\n"
	   	         "\n"
	   	         "\n"
	   	         "%d Tons\n",
	   	         pilot_cargoOwned( player.p, comname ),
	   	         planet_commodityPriceBuying( land_planet, com ),
	   	         round((planet_commodityPriceBuyingRatio( land_planet, com )-1.0)*100),
	   	         tradeData->buyingQuantityRemaining,
	   	         tradeData->buyingQuantity,
	   	         pilot_cargoFree(player.p));
   } else {//both
	   nsnprintf( buf, PATH_MAX,
	   	         "%d Tons\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "(%+g%%)\n"
	   	         "%d/%d t\n"
	   	         "%"CREDITS_PRI" cr/t\n"
	   	         "(%+g%%)\n"
	   	         "%d/%d t\n"
	   	         "\n"
	   	         "%d Tons\n",
	   	         pilot_cargoOwned( player.p, comname ),
	   	         planet_commodityPriceBuying( land_planet, com ),
	   	         round((planet_commodityPriceBuyingRatio( land_planet, com )-1.0)*100),
	   	         tradeData->buyingQuantityRemaining,
	   	         tradeData->buyingQuantity,
	   	         planet_commodityPriceSelling( land_planet, com ),
	   	         round((planet_commodityPriceSellingRatio( land_planet, com )-1.0)*100),
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

   int pos= toolkit_getListPos(wid, "lstGoods" );
   if (pos==-1) {
	   comname=NULL;
   } else {
	   comname=goods[pos];
   }
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
   int pos= toolkit_getListPos(wid, "lstGoods" );
   if (pos==-1) {
	   comname=NULL;
   } else {
	   comname=goods[pos];
   }
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
