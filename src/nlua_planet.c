/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file nlua_planet.c
 *
 * @brief Lua planet module.
 */

#include "nlua_planet.h"

#include "naev.h"

#include <lauxlib.h>

#include "nlua.h"
#include "nluadef.h"
#include "nlua_faction.h"
#include "nlua_vec2.h"
#include "nlua_system.h"
#include "nlua_tex.h"
#include "nlua_ship.h"
#include "nlua_outfit.h"
#include "nlua_commodity.h"
#include "nlua_col.h"
#include "log.h"
#include "rng.h"
#include "land.h"
#include "land_outfits.h"
#include "map.h"
#include "nmath.h"
#include "nstring.h"
#include "tech.h"
#include "space.h"
#include "land.h"


/* Planet metatable methods */
static int planetL_cur( lua_State *L );
static int planetL_get( lua_State *L );
static int planetL_exists( lua_State *L );
static int planetL_getLandable( lua_State *L );
static int planetL_getAll( lua_State *L );
static int planetL_system( lua_State *L );
static int planetL_eq( lua_State *L );
static int planetL_name( lua_State *L );
static int planetL_radius( lua_State *L );
static int planetL_faction( lua_State *L );
static int planetL_colour( lua_State *L );
static int planetL_class( lua_State *L );
static int planetL_position( lua_State *L );
static int planetL_services( lua_State *L );
static int planetL_canland( lua_State *L );
static int planetL_landOverride( lua_State *L );
static int planetL_getLandOverride( lua_State *L );
static int planetL_gfxSpace( lua_State *L );
static int planetL_gfxExterior( lua_State *L );
static int planetL_shipsSold( lua_State *L );
static int planetL_outfitsSold( lua_State *L );
static int planetL_commoditiesSold( lua_State *L );
static int planetL_isBlackMarket( lua_State *L );
static int planetL_isKnown( lua_State *L );
static int planetL_setKnown( lua_State *L );
static int planetL_getLuaData( lua_State *L );
static int planetL_setLuaData( lua_State *L );
static int planetL_addService( lua_State *L );
static int planetL_removeService( lua_State *L );
static int planetL_addTechGroup( lua_State *L );
static int planetL_removeTechGroup( lua_State *L );
static int planetL_shortInfo( lua_State *L );
static int planetL_setShortInfo( lua_State *L );
static int planetL_desc( lua_State *L );
static int planetL_setDesc( lua_State *L );
static int planetL_descSettlements( lua_State *L );
static int planetL_setDescSettlements( lua_State *L );
static int planetL_descHistory( lua_State *L );
static int planetL_setDescHistory( lua_State *L );
static int planetL_setFactionPresence( lua_State *L );
static int planetL_addOrUpdateTradeData( lua_State *L );
static int planetL_setTradeBuySellRation( lua_State *L );
static int planetL_setFactionExtraPresence( lua_State *L );
static const luaL_reg planet_methods[] = {
   { "cur", planetL_cur },
   { "get", planetL_get },
   { "exists", planetL_exists },
   { "getLandable", planetL_getLandable },
   { "getAll", planetL_getAll },
   { "system", planetL_system },
   { "__eq", planetL_eq },
   { "__tostring", planetL_name },
   { "name", planetL_name },
   { "radius", planetL_radius },
   { "faction", planetL_faction },
   { "colour", planetL_colour },
   { "class", planetL_class },
   { "pos", planetL_position },
   { "services", planetL_services },
   { "canLand", planetL_canland },
   { "landOverride", planetL_landOverride },
   { "getLandOverride", planetL_getLandOverride },
   { "gfxSpace", planetL_gfxSpace },
   { "gfxExterior", planetL_gfxExterior },
   { "shipsSold", planetL_shipsSold },
   { "outfitsSold", planetL_outfitsSold },
   { "commoditiesSold", planetL_commoditiesSold },
   { "blackmarket", planetL_isBlackMarket },
   { "known", planetL_isKnown },
   { "setKnown", planetL_setKnown },
   { "getLuaData", planetL_getLuaData },
   { "setLuaData", planetL_setLuaData },
   { "addService", planetL_addService },
   { "removeService", planetL_removeService },
   { "addTechGroup", planetL_addTechGroup },
   { "removeTechGroup", planetL_removeTechGroup },
   { "setFactionPresence", planetL_setFactionPresence },
   { "desc", planetL_desc },
   { "setDesc", planetL_setDesc },
   { "shortInfo", planetL_shortInfo },
   { "setShortInfo", planetL_setShortInfo },
   { "descSettlements", planetL_descSettlements },
   { "setDescSettlements", planetL_setDescSettlements },
   { "descHistory", planetL_descHistory },
   { "setDescHistory", planetL_setDescHistory },
   { "addOrUpdateTradeData", planetL_addOrUpdateTradeData },
   { "setTradeBuySellRation", planetL_setTradeBuySellRation },
   { "setFactionExtraPresence", planetL_setFactionExtraPresence },

   {0,0}
}; /**< Planet metatable methods. */
static const luaL_reg planet_cond_methods[] = {
   { "cur", planetL_cur },
   { "get", planetL_get },
   { "exists", planetL_exists },
   { "getLandable", planetL_getLandable },
   { "getAll", planetL_getAll },
   { "system", planetL_system },
   { "__eq", planetL_eq },
   { "__tostring", planetL_name },
   { "name", planetL_name },
   { "radius", planetL_radius },
   { "faction", planetL_faction },
   { "colour", planetL_colour },
   { "class", planetL_class },
   { "pos", planetL_position },
   { "services", planetL_services },
   { "canLand", planetL_canland },
   { "getLandOverride", planetL_getLandOverride },
   { "gfxSpace", planetL_gfxSpace },
   { "gfxExterior", planetL_gfxExterior },
   { "shipsSold", planetL_shipsSold },
   { "outfitsSold", planetL_outfitsSold },
   { "commoditiesSold", planetL_commoditiesSold },
   { "blackmarket", planetL_isBlackMarket },
   { "known", planetL_isKnown },
   { "getLuaData", planetL_getLuaData },
   { "setLuaData", planetL_setLuaData },
   { "addService", planetL_addService },
   { "removeService", planetL_removeService },
   { "addTechGroup", planetL_addTechGroup },
   { "removeTechGroup", planetL_removeTechGroup },
   { "setFactionPresence", planetL_setFactionPresence },
   { "shortInfo", planetL_shortInfo },
   { "setShortInfo", planetL_setShortInfo },
   { "desc", planetL_desc },
   { "setDesc", planetL_setDesc },
   { "descSettlements", planetL_descSettlements },
   { "setDescSettlements", planetL_setDescSettlements },
   { "descHistory", planetL_descHistory },
   { "setDescHistory", planetL_setDescHistory },
   { "addOrUpdateTradeData", planetL_addOrUpdateTradeData },
   { "setTradeBuySellRation", planetL_setTradeBuySellRation },
   {0,0}
}; /**< Read only planet metatable methods. */


/**
 * @brief Loads the planet library.
 *
 *    @param L State to load planet library into.
 *    @param readonly Load read only functions?
 *    @return 0 on success.
 */
int nlua_loadPlanet( lua_State *L, int readonly )
{
   /* Create the metatable */
   luaL_newmetatable(L, PLANET_METATABLE);

   /* Create the access table */
   lua_pushvalue(L,-1);
   lua_setfield(L,-2,"__index");

   /* Register the values */
   if (readonly)
      luaL_register(L, NULL, planet_cond_methods);
   else
      luaL_register(L, NULL, planet_methods);

   /* Clean up. */
   lua_setfield(L, LUA_GLOBALSINDEX, PLANET_METATABLE);

   return 0; /* No error */
}


/**
 * @brief This module allows you to handle the planets from Lua.
 *
 * Generally you do something like:
 *
 * @code
 * p,s = planet.get() -- Get current planet and system
 * if p:services()["inhabited"] > 0 then -- planet is inhabited
 *    v = p:pos() -- Get the position
 *    -- Do other stuff
 * end
 * @endcode
 *
 * @luamod planet
 */
/**
 * @brief Gets planet at index.
 *
 *    @param L Lua state to get planet from.
 *    @param ind Index position to find the planet.
 *    @return Planet found at the index in the state.
 */
LuaPlanet* lua_toplanet( lua_State *L, int ind )
{
   return (LuaPlanet*) lua_touserdata(L,ind);
}
/**
 * @brief Gets planet at index raising an error if isn't a planet.
 *
 *    @param L Lua state to get planet from.
 *    @param ind Index position to find the planet.
 *    @return Planet found at the index in the state.
 */
LuaPlanet* luaL_checkplanet( lua_State *L, int ind )
{
   if (lua_isplanet(L,ind))
      return lua_toplanet(L,ind);
   luaL_typerror(L, ind, PLANET_METATABLE);
   return NULL;
}
/**
 * @brief Gets a planet directly.
 *
 *    @param L Lua state to get planet from.
 *    @param ind Index position to find the planet.
 *    @return Planet found at the index in the state.
 */
Planet* luaL_validplanet( lua_State *L, int ind )
{
   LuaPlanet *lp;
   Planet *p;

   if (lua_isplanet(L, ind)) {
      lp = luaL_checkplanet(L, ind);
      p  = planet_getIndex(*lp);
   }
   else if (lua_isstring(L, ind))
      p = planet_get( lua_tostring(L, ind) );
   else {
      luaL_typerror(L, ind, PLANET_METATABLE);
      return NULL;
   }

   if (p == NULL)
      NLUA_ERROR(L, "Planet is invalid");

   return p;
}
/**
 * @brief Pushes a planet on the stack.
 *
 *    @param L Lua state to push planet into.
 *    @param planet Planet to push.
 *    @return Newly pushed planet.
 */
LuaPlanet* lua_pushplanet( lua_State *L, LuaPlanet planet )
{
   LuaPlanet *p;
   p = (LuaPlanet*) lua_newuserdata(L, sizeof(LuaPlanet));
   *p = planet;
   luaL_getmetatable(L, PLANET_METATABLE);
   lua_setmetatable(L, -2);
   return p;
}
/**
 * @brief Checks to see if ind is a planet.
 *
 *    @param L Lua state to check.
 *    @param ind Index position to check.
 *    @return 1 if ind is a planet.
 */
int lua_isplanet( lua_State *L, int ind )
{
   int ret;

   if (lua_getmetatable(L,ind)==0)
      return 0;
   lua_getfield(L, LUA_REGISTRYINDEX, PLANET_METATABLE);

   ret = 0;
   if (lua_rawequal(L, -1, -2))  /* does it have the correct mt? */
      ret = 1;

   lua_pop(L, 2);  /* remove both metatables */
   return ret;
}


/**
 * @brief Gets the current planet - MUST BE LANDED.
 *
 * @usage p,s = planet.cur() -- Gets current planet (assuming landed)
 *
 *    @luatreturn Planet The planet the player is landed on.
 *    @luatreturn System The system it is in.
 * @luafunc cur()
 */
static int planetL_cur( lua_State *L )
{
   LuaSystem sys;
   if (land_planet == NULL) {
      NLUA_ERROR(L,"Attempting to get landed planet when player not landed.");
      return 0; /* Not landed. */
   }
   lua_pushplanet(L,planet_index(land_planet));
   sys = system_index( system_get( planet_getSystem(land_planet->name) ) );
   lua_pushsystem(L,sys);
   return 2;
}


static int planetL_getBackend( lua_State *L, int landable )
{
   int i;
   int *factions;
   int nfactions;
   char **planets;
   int nplanets;
   const char *rndplanet;
   LuaSystem luasys;
   LuaFaction f;
   Planet *pnt;
   StarSystem *sys;
   char *sysname;

   rndplanet = NULL;
   planets   = NULL;
   nplanets  = 0;

   /* If boolean return random. */
   if (lua_isboolean(L,1)) {
      pnt            = planet_get( space_getRndPlanet(landable, 0, NULL) );
      lua_pushplanet(L,planet_index( pnt ));
      luasys         = system_index( system_get( planet_getSystem(pnt->name) ) );
      lua_pushsystem(L,luasys);
      return 2;
   }

   /* Get a planet by faction */
   else if (lua_isfaction(L,1)) {
      f        = lua_tofaction(L,1);
      planets  = space_getFactionPlanet( &nplanets, &f, 1, landable );
   }

   /* Get a planet by name */
   else if (lua_isstring(L,1)) {
      rndplanet = lua_tostring(L,1);

      if (landable) {
         pnt = planet_get( rndplanet );
         if (pnt == NULL) {
            NLUA_ERROR(L, "Planet '%s' not found in stack", rndplanet);
            return 0;
         }

         /* Check if can land. */
         planet_updateLand( pnt );
         if (!pnt->can_land)
            return 0;
      }
   }

   /* Get a planet from faction list */
   else if (lua_istable(L,1)) {
      /* Get table length and preallocate. */
      nfactions = (int) lua_objlen(L,1);
      factions = malloc( sizeof(int) * nfactions );
      /* Load up the table. */
      lua_pushnil(L);
      i = 0;
      while (lua_next(L, -2) != 0) {
         if (lua_isfaction(L, -1))
            factions[i++] = lua_tofaction(L, -1);
         lua_pop(L,1);
      }

      /* get the planets */
      planets = space_getFactionPlanet( &nplanets, factions, nfactions, landable );
      free(factions);
   }
   else
      NLUA_INVALID_PARAMETER(L); /* Bad Parameter */

   /* No suitable planet found */
   if ((rndplanet == NULL) && ((planets == NULL) || nplanets == 0))
      return 0;
   /* Pick random planet */
   else if (rndplanet == NULL) {
      planets = (char**) arrayShuffle( (void**)planets, nplanets );

      for (i=0; i<nplanets; i++) {
         if (landable) {
            /* Check landing. */
            pnt = planet_get( planets[i] );
            if (pnt == NULL)
               continue;

            planet_updateLand( pnt );
            if (!pnt->can_land)
               continue;
         }

         rndplanet = planets[i];
         break;
      }
      free(planets);
   }

   /* Push the planet */
   pnt = planet_get(rndplanet); /* The real planet */
   if (pnt == NULL) {
      NLUA_ERROR(L, "Planet '%s' not found in stack", rndplanet);
      return 0;
   }
   sysname = planet_getSystem(rndplanet);
   if (sysname == NULL) {
      NLUA_ERROR(L, "Planet '%s' is not placed in a system", rndplanet);
      return 0;
   }
   sys = system_get( sysname );
   if (sys == NULL) {
      NLUA_ERROR(L, "Planet '%s' can't find system '%s'", rndplanet, sysname);
      return 0;
   }
   lua_pushplanet(L,planet_index( pnt ));
   luasys = system_index( sys );
   lua_pushsystem(L,luasys);
   return 2;
}

/**
 * @brief Gets a planet.
 *
 * Possible values of param: <br/>
 *    - bool : Gets a random planet. <br/>
 *    - faction : Gets random planet belonging to faction matching the number. <br/>
 *    - string : Gets the planet by name. <br/>
 *    - table : Gets random planet belonging to any of the factions in the
 *               table. <br/>
 *
 * @usage p,s = planet.get( "Anecu" ) -- Gets planet by name
 * @usage p,s = planet.get( faction.get( "Empire" ) ) -- Gets random Empire planet
 * @usage p,s = planet.get(true) -- Gets completely random planet
 * @usage p,s = planet.get( { faction.get("Empire"), faction.get("Dvaered") } ) -- Random planet belonging to Empire or Dvaered
 *    @luatparam boolean|Faction|string|table param See description.
 *    @luatreturn Planet The matching planet.
 *    @luatreturn System The system it is in.
 * @luafunc get( param )
 */
static int planetL_get( lua_State *L )
{
   return planetL_getBackend( L, 0 );
}


/**
 * @brief Gets a planet only if it's landable.
 *
 * It works exactly the same as planet.get(), but it can only return landable
 * planets. So if the target is not landable it returns nil.
 *
 *    @luatparam boolean|Faction|string|table param See planet.get() description.
 *    @luatreturn Planet The matching planet, if it is landable.
 *    @luatreturn System The system it is in.
 * @luafunc getLandable( param )
 */
static int planetL_getLandable( lua_State *L )
{
   return planetL_getBackend( L, 1 );
}


/**
 * @brief Gets all the planets.
 *    @luatreturn {Planet,...} An ordered list of all the planets.
 * @luafunc getAll()
 */
static int planetL_getAll( lua_State *L )
{
   Planet *p;
   int i, ind, n;

   lua_newtable(L);
   p = planet_getAll( &n );
   ind = 1;
   for (i=0; i<n; i++) {
      /* Ignore virtual assets. */
      if (p[i].real == ASSET_VIRTUAL)
         continue;
      lua_pushnumber( L, ind++ );
      lua_pushplanet( L, planet_index( &p[i] ) );
      lua_settable(   L, -3 );
   }
   return 1;
}


/**
 * @brief Gets the system corresponding to a planet.
 *    @luatparam Planet p Planet to get system of.
 *    @luatreturn System|nil The system to which the planet belongs or nil if it has none.
 * @luafunc system( p )
 */
static int planetL_system( lua_State *L )
{
   LuaSystem sys;
   Planet *p;
   const char *sysname;
   /* Arguments. */
   p = luaL_validplanet(L,1);
   sysname = planet_getSystem( p->name );
   if (sysname == NULL)
      return 0;
   sys = system_index( system_get( sysname ) );
   lua_pushsystem( L, sys );
   return 1;
}

/**
 * @brief You can use the '=' operator within Lua to compare planets with this.
 *
 * @usage if p.__eq( planet.get( "Anecu" ) ) then -- Do something
 * @usage if p == planet.get( "Anecu" ) then -- Do something
 *    @luatparam Planet p Planet comparing.
 *    @luatparam Planet comp planet to compare against.
 *    @luatreturn boolean true if both planets are the same.
 * @luafunc __eq( p, comp )
 */
static int planetL_eq( lua_State *L )
{
   LuaPlanet *a, *b;
   a = luaL_checkplanet(L,1);
   b = luaL_checkplanet(L,2);
   lua_pushboolean(L,(*a == *b));
   return 1;
}

/**
 * @brief Gets the planet's name.
 *
 * @usage name = p:name()
 *    @luatparam Planet p Planet to get the name of.
 *    @luatreturn string The name of the planet.
 * @luafunc name( p )
 */
static int planetL_name( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->name);
   return 1;
}


/**
 * @brief Gets the planet's short info text.
 *
 * @usage desc = p:shortInfo()
 *    @luaparam p Planet to get the short info of.
 *    @luareturn The short info of the planet.
 * @luafunc shortInfo( p )
 */
static int planetL_shortInfo( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->shortInfo);
   return 1;
}

/**
 * @brief Sets a planets's short info.
 *
 * @usage p:setShortInfo( shortInfo )
 *    @luaparam p Planet to set short info.
 *    @luaparam shortInfo The short info
 * @luafunc setShortInfo( p, shortInfo )
 */
static int planetL_setShortInfo( lua_State *L )
{
   const char* shortInfo;
   Planet *p;

   p = luaL_validplanet(L,1);
   shortInfo = lua_tostring(L, 2);

   if (p->shortInfo!=NULL)
	   free(p->shortInfo);

   p->shortInfo=strdup(shortInfo);

   return 0;
}



/**
 * @brief Gets the planet's desc.
 *
 * @usage desc = p:desc()
 *    @luaparam p Planet to get the desc of.
 *    @luareturn The desc of the planet.
 * @luafunc desc( p )
 */
static int planetL_desc( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->description);
   return 1;
}

/**
 * @brief Sets a planets's desc.
 *
 * @usage p:setDesc( desc )
 *    @luaparam p Planet to set desc.
 *    @luaparam desc The desc
 * @luafunc setKnown( p, desc )
 */
static int planetL_setDesc( lua_State *L )
{
   const char* desc;
   Planet *p;

   p = luaL_validplanet(L,1);
   desc = lua_tostring(L, 2);

   if (p->description!=NULL)
	   free(p->description);

   p->description=strdup(desc);

   land_refresh_screen();

   planet_setSaveFlag(p,PLANET_DESC_SAVE);//desc is now custom and must be saved

   return 0;
}

/**
 * @brief Gets the planet's settlements desc.
 *
 * @usage desc = p:descSettlements()
 *    @luaparam p Planet to get the settlements desc of.
 *    @luareturn The settlements desc of the planet.
 * @luafunc desc( p )
 */
static int planetL_descSettlements( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->settlements_description);
   return 1;
}

/**
 * @brief Sets a planets's settlements desc.
 *
 * @usage p:setDescSettlements( desc )
 *    @luaparam p Planet to set settlements desc.
 *    @luaparam desc The desc
 * @luafunc setKnown( p, desc )
 */
static int planetL_setDescSettlements( lua_State *L )
{
   const char* desc;
   Planet *p;

   p = luaL_validplanet(L,1);
   desc = lua_tostring(L, 2);

   if (p->settlements_description!=NULL)
	   free(p->settlements_description);

   p->settlements_description=strdup(desc);

   planet_setSaveFlag(p,PLANET_DESC_SAVE);//desc is now custom and must be saved

   land_refresh_screen();

   return 0;
}

/**
 * @brief Gets the planet's history desc.
 *
 * @usage desc = p:descHistory()
 *    @luaparam p Planet to get the history desc of.
 *    @luareturn The history desc of the planet.
 * @luafunc desc( p )
 */
static int planetL_descHistory( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->history_description);
   return 1;
}

/**
 * @brief Sets a planets's history desc.
 *
 * @usage p:setDescHistory( desc )
 *    @luaparam p Planet to set history desc.
 *    @luaparam desc The desc
 * @luafunc setKnown( p, desc )
 */
static int planetL_setDescHistory( lua_State *L )
{
   const char* desc;
   Planet *p;

   p = luaL_validplanet(L,1);
   desc = lua_tostring(L, 2);

   if (p->history_description!=NULL)
	   free(p->history_description);

   p->history_description=strdup(desc);

   land_refresh_screen();

   planet_setSaveFlag(p,PLANET_DESC_SAVE);//desc is now custom and must be saved

   return 0;
}

/**
 * @brief Gets the planet's radius.
 *
 * @usage radius = p:radius()
 *    @luatparam Planet p Planet to get the radius of.
 *    @luatreturn number The planet's graphics radius.
 * @luafunc name( p )
 */
static int planetL_radius( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushnumber(L,p->radius);
   return 1;
}

/**
 * @brief Gets the planet's faction.
 *
 * @usage f = p:faction()
 *    @luatparam Planet p Planet to get the faction of.
 *    @luatreturn Faction The planet's faction.
 * @luafunc faction( p )
 */
static int planetL_faction( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   if (p->faction < 0)
      return 0;
   lua_pushfaction(L, p->faction);
   return 1;
}


/**
 * @brief Gets a planet's colour based on its friendliness or hostility to the player.
 *
 * @usage col = p:colour()
 *
 *    @luatparam Pilot p Planet to get the colour of.
 *    @luatreturn Colour The planet's colour.
 * @luafunc colour( p )
 */
static int planetL_colour( lua_State *L )
{
   Planet *p;
   const glColour *col;

   p = luaL_validplanet(L,1);
   col = planet_getColour( p );

   lua_pushcolour( L, *col );

   return 1;
}


/**
 * @brief Gets the planet's class.
 *
 * Usually classes are characters for planets and numbers
 * for stations.
 *
 * @usage c = p:class()
 *    @luatparam Planet p Planet to get the class of.
 *    @luatreturn string The class of the planet in a one char identifier.
 * @luafunc class( p )
 */
static int planetL_class(lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushstring(L,p->class);
   return 1;
}


/**
 * @brief Checks for planet services.
 *
 * Possible services are:<br />
 *  - "land"<br />
 *  - "inhabited"<br />
 *  - "refuel"<br />
 *  - "bar"<br />
 *  - "missions"<br />
 *  - "commodity"<br />
 *  - "outfits"<br />
 *  - "shipyard"<br />
 *
 * @usage if p:services()["refuel"] then -- Planet has refuel service.
 * @usage if p:services()["shipyard"] then -- Planet has shipyard service.
 *    @luatparam Planet p Planet to get the services of.
 *    @luatreturn table Table containing all the services.
 * @luafunc services( p )
 */
static int planetL_services( lua_State *L )
{
   int i;
   size_t len;
   Planet *p;
   char *name, lower[256];
   p = luaL_validplanet(L,1);

   /* Return result in table */
   lua_newtable(L);

   /* allows syntax like foo = planet.get("foo"); if foo["bar"] then ... end */
   for (i=1; i<PLANET_SERVICES_MAX; i<<=1) {
      if (planet_hasService(p, i)) {
         name = planet_getServiceName(i);
         len = strlen(name) + 1;
         nsnprintf( lower, MIN(len,sizeof(lower)), "%c%s", tolower(name[0]), &name[1] );

         lua_pushstring(L, name);
         lua_setfield(L, -2, lower );
      }
   }
   return 1;
}


/**
 * @brief Gets whether or not the player can land on the planet (or bribe it).
 *
 * @usage can_land, can_bribe = p:canLand()
 *    @luatparam Planet p Planet to get land and bribe status of.
 *    @luatreturn boolean The land status of the planet.
 *    @luatreturn boolean The bribability status of the planet.
 * @luafunc canLand( p )
 */
static int planetL_canland( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   planet_updateLand( p );
   lua_pushboolean( L, p->can_land );
   lua_pushboolean( L, p->bribe_price > 0 );
   return 2;
}


/**
 * @brief Lets player land on a planet no matter what. The override lasts until the player jumps or lands.
 *
 * @usage p:landOverride( true ) -- Planet can land on p now.
 *    @luatparam Planet p Planet to forcibly allow the player to land on.
 *    @luatparam[opt=false] boolean b Whether or not the player should be allowed to land, true enables, false disables override.
 * @luafunc landOverride( p, b )
 */
static int planetL_landOverride( lua_State *L )
{
   Planet *p;
   int old;

   p   = luaL_validplanet(L,1);
   old = p->land_override;

   p->land_override = !!lua_toboolean(L,2);

   /* If the value has changed, re-run the landing Lua next frame. */
   if (p->land_override != old)
      space_factionChange();

   return 0;
}


/**
 * @brief Gets the land override status for a planet.
 *
 * @usage if p:getLandOverride() then -- Player can definitely land.
 *    @luatparam Planet p Planet to check.
 *    @luatreturn b Whether or not the player is always allowed to land.
 * @luafunc getLandOverride( p )
 */
static int planetL_getLandOverride( lua_State *L )
{
   Planet *p = luaL_validplanet(L,1);
   lua_pushboolean(L, p->land_override);
   return 1;
}


/**
 * @brief Gets the position of the planet in the system.
 *
 * @usage v = p:pos()
 *    @luatparam Planet p Planet to get the position of.
 *    @luatreturn Vec2 The position of the planet in the system.
 * @luafunc pos( p )
 */
static int planetL_position( lua_State *L )
{
   Planet *p;
   p = luaL_validplanet(L,1);
   lua_pushvector(L, p->pos);
   return 1;
}


/**
 * @brief Gets the texture of the planet in space.
 *
 * @uasge gfx = p:gfxSpace()
 *    @luatparam Planet p Planet to get texture of.
 *    @luatreturn Tex The space texture of the planet.
 * @luafunc gfxSpace( p )
 */
static int planetL_gfxSpace( lua_State *L )
{
   Planet *p;
   glTexture *tex;
   p        = luaL_validplanet(L,1);
   if (p->gfx_space == NULL) /* Not loaded. */
      tex = gl_newImage( p->gfx_spaceName, OPENGL_TEX_MIPMAPS );
   else
      tex = gl_dupTexture( p->gfx_space );
   lua_pushtex( L, tex );
   return 1;
}


/**
 * @brief Gets the texture of the planet in exterior.
 *
 * @uasge gfx = p:gfxExterior()
 *    @luatparam Planet p Planet Planet to get texture of.
 *    @luatreturn Tex The exterior texture of the planet.
 * @luafunc gfxExterior( p )
 */
static int planetL_gfxExterior( lua_State *L )
{
   Planet *p;
   p        = luaL_validplanet(L,1);
   lua_pushtex( L, gl_newImage( p->gfx_exterior, 0 ) );
   return 1;
}


/**
 * @brief Gets the ships sold at a planet.
 *
 *    @luatparam Planet p Planet to get ships sold at.
 *    @luatreturn {Ship,...} An ordered table containing all the ships sold (empty if none sold).
 * @luafunc shipsSold( p )
 */
static int planetL_shipsSold( lua_State *L )
{
   Planet *p;
   int i, n;
   Ship **s;

   /* Get result and tech. */
   p = luaL_validplanet(L,1);
   s = tech_getShip( p->tech, &n );

   /* Push results in a table. */
   lua_newtable(L);
   for (i=0; i<n; i++) {
      lua_pushnumber(L,i+1); /* index, starts with 1 */
      lua_pushship(L,s[i]); /* value = LuaShip */
      lua_rawset(L,-3); /* store the value in the table */
   }

   return 1;
}


/**
 * @brief Gets the outfits sold at a planet.
 *
 *    @luatparam Planet p Planet to get outfits sold at.
 *    @luatreturn {Outfit,...} An ordered table containing all the outfits sold (empty if none sold).
 * @luafunc outfitsSold( p )
 */
static int planetL_outfitsSold( lua_State *L )
{
   Planet *p;
   int i, n;
   Outfit **o;

   /* Get result and tech. */
   p = luaL_validplanet(L,1);
   o = tech_getOutfit( p->tech, &n );

   /* Push results in a table. */
   lua_newtable(L);
   for (i=0; i<n; i++) {
      lua_pushnumber(L,i+1); /* index, starts with 1 */
      lua_pushoutfit(L,o[i]); /* value = LuaOutfit */
      lua_rawset(L,-3); /* store the value in the table */
   }

   return 1;
}


/**
 * @brief Gets the commodities sold at a planet.
 *
 *    @luatparam Pilot p Planet to get commodities sold at.
 *    @luatreturn {Commodity,...} An ordered table containing all the commodities sold (empty if none sold).
 * @luafunc commoditiesSold( p )
 */
static int planetL_commoditiesSold( lua_State *L )
{
   Planet *p;
   int i, n;
   Commodity **c;

   /* Get result and tech. */
   p = luaL_validplanet(L,1);
   c = tech_getCommodity( p->tech, &n );

   /* Push results in a table. */
   lua_newtable(L);
   for (i=0; i<n; i++) {
      lua_pushnumber(L,i+1); /* index, starts with 1 */
      lua_pushcommodity(L,c[i]); /* value = LuaCommodity */
      lua_rawset(L,-3); /* store the value in the table */
   }

   return 1;
}

/**
 * @brief Checks to see if a planet is a black market.
 *
 * @usage b = p:blackmarket()
 *
 *    @luatparam Planet p Planet to check if it's a black market.
 *    @luatreturn boolean true if the planet is a black market.
 * @luafunc blackmarket( p )
 */
static int planetL_isBlackMarket( lua_State *L )
{
   Planet *p = luaL_validplanet(L,1);
   lua_pushboolean(L, planet_isBlackMarket(p));
   return 1;
}

/**
 * @brief Checks to see if a planet is known by the player.
 *
 * @usage b = p:known()
 *
 *    @luatparam Planet p Planet to check if the player knows.
 *    @luatreturn boolean true if the player knows the planet.
 * @luafunc known( p )
 */
static int planetL_isKnown( lua_State *L )
{
   Planet *p = luaL_validplanet(L,1);
   lua_pushboolean(L, planet_isKnown(p));
   return 1;
}

/**
 * @brief Sets a planets's known state.
 *
 * @usage p:setKnown( false ) -- Makes planet unknown.
 *    @luatparam Planet p Planet to set known.
 *    @luatparam[opt=false] boolean b Whether or not to set as known.
 * @luafunc setKnown( p, b )
 */
static int planetL_setKnown( lua_State *L )
{
   int b, changed;
   Planet *p;

   p = luaL_validplanet(L,1);
   b = lua_toboolean(L, 2);

   changed = (b != (int)planet_isKnown(p));

   if (b)
      planet_setKnown( p );
   else
      planet_rmFlag( p, PLANET_KNOWN );

   /* Update outfits image array. */
   if (changed)
      outfits_updateEquipmentOutfits();

   return 0;
}

/**
 * @brief checks if a planet or asset exists
 *
 *    @luaparam param Name of the planet
 *    @luareturn boolean
 * @luafunc get( param )
 */
static int planetL_exists( lua_State *L )
{

        if (planet_exists( lua_tostring(L,1) )) {
            lua_pushboolean(L,1);
        } else {
            lua_pushboolean(L,0);
        }

       return 1;
}

/**
 * @brief Gets the lua data
 *
 * @uasge gfx = p:getLuaData()
 *    @luaparam p Planet to get lua data of.
 *    @luareturn The lua data of the planet.
 * @luafunc getLuaData( p )
 */
static int planetL_getLuaData( lua_State *L )
{
   Planet *p;
   p        = luaL_validplanet(L,1);
   if (p->luaData == NULL)
	   lua_pushstring(L,"{}");
   else
	   lua_pushstring(L,p->luaData);
   return 1;
}


/**
 * @brief Sets a planets's lua data.
 *
 * @usage p:setLuaData( luaData ) sets lua data
 *    @luaparam p Planet to set lua data for.
 *    @luaparam b lua data
 * @luafunc setLuaData( p, b )
 */
static int planetL_setLuaData( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   p->luaData=strdup(lua_tostring(L, 2));

   return 0;
}

/**
 * @brief Add a service to the planet
 *
 * Service codes:
 * r : refuel
 * b : bar
 * c : commodities
 * o : outfits
 * s : shipyards
 *
 * @usage p:addService( s )
 *    @luaparam p Planet to add service to
 *    @luaparam s code for service
 * @luafunc addService( p, s )
 */
static int planetL_addService( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* servicestr=lua_tostring(L, 2);

   if (strlen(servicestr)==1) {
	   char service=servicestr[0];

	   if (service=='r')
		   p->services |= PLANET_SERVICE_REFUEL | PLANET_SERVICE_INHABITED;
	   else if (service=='b')
		   p->services |= PLANET_SERVICE_BAR | PLANET_SERVICE_INHABITED;
	   else if (service=='m')
		   p->services |= PLANET_SERVICE_MISSIONS | PLANET_SERVICE_INHABITED;
	   else if (service=='c')
		   p->services |= PLANET_SERVICE_COMMODITY | PLANET_SERVICE_INHABITED;
	   else if (service=='o')
		   p->services |= PLANET_SERVICE_OUTFITS | PLANET_SERVICE_INHABITED;
	   else if (service=='s')
		   p->services |= PLANET_SERVICE_SHIPYARD | PLANET_SERVICE_INHABITED;

	   planet_setSaveFlag(p,PLANET_SERVICES_SAVE);//services are now custom and must be saved
   }

   return 0;
}

/**
 * @brief Removes a service to the planet
 *
 * Service codes:
 * r : refuel
 * b : bar
 * c : commodities
 * o : outfits
 * s : shipyards
 *
 * @usage p:removeService(s )
 *    @luaparam p Planet to remove service to
 *    @luaparam s code for service
 * @luafunc removeService( p, s )
 */
static int planetL_removeService( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* servicestr=lua_tostring(L, 2);

   if (strlen(servicestr)==1) {
	   char service=servicestr[0];

	   if (service=='r')
		   p->services &= ~ PLANET_SERVICE_REFUEL;
	   else if (service=='b')
		   p->services &= ~ PLANET_SERVICE_BAR;
	   else if (service=='m')
		   p->services &= ~ PLANET_SERVICE_MISSIONS;
	   else if (service=='c')
		   p->services &= ~ PLANET_SERVICE_COMMODITY;
	   else if (service=='o')
		   p->services &= ~ PLANET_SERVICE_OUTFITS;
	   else if (service=='s')
		   p->services &= ~ PLANET_SERVICE_SHIPYARD;

	   planet_setSaveFlag(p,PLANET_SERVICES_SAVE);//services are now custom and must be saved
   }

   return 0;
}

/**
 * @brief Add a tech group to the planet
 *
 * @usage p:addTechGroup( groupName )
 *    @luaparam p Planet to add tech group to
 *    @luaparam groupName name of the tech group
 * @luafunc addTechGroup( p, groupName )
 */
static int planetL_addTechGroup( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* techGroupName=lua_tostring(L, 2);

   if (p->tech==NULL)
	   p->tech= tech_groupCreate();

   tech_addItemTech(p->tech,techGroupName);

   planet_setSaveFlag(p,PLANET_TECH_SAVE);//techs are now custom and must be saved

   return 0;
}

/**
 * @brief Removes a tech group from the planet
 *
 * @usage p:removeTechGroup( groupName )
 *    @luaparam p Planet to remove tech group from
 *    @luaparam groupName name of the tech group
 * @luafunc addTechGroup( p, groupName )
 */
static int planetL_removeTechGroup( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* techGroupName=lua_tostring(L, 2);

   if (p->tech==NULL)
	   return 0;

   if (tech_hasItem(p->tech,strdup(techGroupName)))
	   tech_rmItemTech(p->tech,techGroupName);

   planet_setSaveFlag(p,PLANET_TECH_SAVE);//techs are now custom and must be saved

   return 0;
}

/**
 * @brief Sets a planet's faction & presence
 *
 * @usage p:setFactionPresence( factionName, factionValue, factionRange)
 *    @luaparam p Planet to set faction & presence for
 *    @luaparam factionName name of the faction. Empty string for none.
 *    @luaparam factionValue strength of the presence.
 *    @luaparam factionRange range the presence extends too.
 * @luafunc setFactionPresence(p, factionName, factionValue, factionRange)
 */
static int planetL_setFactionPresence( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* factionName=lua_tostring(L, 2);

   if (strlen(factionName)==0) {
	   p->faction=0;
	   p->presenceAmount=0;
	   p->presenceRange=0;
   } else {
	   p->faction=faction_get(factionName);
	   p->presenceAmount=luaL_checknumber(L,3);
	   p->presenceRange=luaL_checknumber(L,4);
   }

   planet_setSaveFlag(p,PLANET_PRESENCE_SAVE);//faction & presence are now custom and must be saved

   space_reconstructPresences();

   return 0;
}

/**
 * @brief Sets a planet's extra presence for a faction
 *
 * @usage p:setFactionPresence( factionName, factionValue, factionRange)
 *    @luaparam p Planet to set extra presence for
 *    @luaparam factionName name of the faction.
 *    @luaparam factionValue strength of the presence.
 *    @luaparam factionRange range the presence extends too.
 * @luafunc setFactionPresence(p, factionName, factionValue, factionRange)
 */
static int planetL_setFactionExtraPresence( lua_State *L )
{
   Planet *p;

   p = luaL_validplanet(L,1);
   const char* factionName=lua_tostring(L, 2);
   int factionId=faction_get(factionName);
   double amount=luaL_checknumber(L,3);
   int range=luaL_checknumber(L,4);

   planet_addOrUpdateExtraPresence(p,factionId,amount,range);

   space_reconstructPresences();

   return 0;
}

/**
 * @brief Adds or update a trade data for a planet
 *
 * @usage p:addOrUpdateTradeData( buyingPriceFactor, sellingPriceFactor, buyingQuantity, sellingQuantity)
 *    @luaparam p Planet to add or update trade data for
 *    @luaparam commodity Commodity the trade data is for
 *    @luaparam buyingPriceFactor Multiplier for the base price when buying
 *    @luaparam sellingPriceFactor Multiplier of the base price when selling
 *    @luaparam buyingQuantity Max quantity the world will buy from the player
 *    @luaparam sellingQuantity Max quantity the world will sell to the player
 * @luafunc addOrUpdateTradeData( p, buyingPriceFactor, sellingPriceFactor, buyingQuantity, sellingQuantity)
 */
static int planetL_addOrUpdateTradeData( lua_State *L )
{
   Planet *p;
   Commodity *c;

   p = luaL_validplanet(L,1);
   c  = luaL_validcommodity(L,2);
	float priceFactor=luaL_checknumber(L,3);
	int buyingQuantity=luaL_checknumber(L,4);
	int sellingQuantity=luaL_checknumber(L,5);

	planet_addOrUpdateTradeData(p,c,priceFactor,buyingQuantity,sellingQuantity);

   planet_setSaveFlag(p,PLANET_COMMODITIES_SAVE);//trade datas are now custom and must be saved

   //space_refresh();

   return 0;
}

/**
 * @brief Sets the buy-sell ratio for a planet (the difference in buying and selling prices compared to base price)
 *
 * @usage p:setTradeBuySellRation( priceFactor)
 *    @luaparam p Planet to add or update trade data for
 *    @luaparam buy-sell ratio
 * @luafunc setTradeBuySellRation( p, priceFactor)
 */
static int planetL_setTradeBuySellRation( lua_State *L )
{
	Planet *p;

	p = luaL_validplanet(L,1);
	float ratio=luaL_checknumber(L,2);

	p->buySellGap=ratio;

	planet_setSaveFlag(p,PLANET_COMMODITIES_SAVE);//trade datas are now custom and must be saved

	//space_refresh();

	return 0;
}
