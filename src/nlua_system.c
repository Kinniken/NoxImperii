/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file nlua_system.c
 *
 * @brief Lua system module.
 */

#include "nlua_system.h"

#include "naev.h"

#include <lauxlib.h>

#include "nlua.h"
#include "nluadef.h"
#include "nlua_faction.h"
#include "nlua_vec2.h"
#include "nlua_planet.h"
#include "nlua_jump.h"
#include "log.h"
#include "rng.h"
#include "land.h"
#include "land_outfits.h"
#include "map.h"
#include "map_overlay.h"
#include "space.h"


/* System metatable methods */
static int systemL_cur( lua_State *L );
static int systemL_get( lua_State *L );
static int systemL_getAll( lua_State *L );
static int systemL_eq( lua_State *L );
static int systemL_name( lua_State *L );
static int systemL_coords( lua_State *L );
static int systemL_sunSpaceNames( lua_State *L );
static int systemL_faction( lua_State *L );
static int systemL_nebula( lua_State *L );
static int systemL_jumpdistance( lua_State *L );
static int systemL_jumpPath( lua_State *L );
static int systemL_adjacent( lua_State *L );
static int systemL_withinradius( lua_State *L );
static int systemL_jumps( lua_State *L );
static int systemL_presences( lua_State *L );
static int systemL_planets( lua_State *L );
static int systemL_presence( lua_State *L );
static int systemL_radius( lua_State *L );
static int systemL_isknown( lua_State *L );
static int systemL_setknown( lua_State *L );
static int systemL_mrkClear( lua_State *L );
static int systemL_mrkAdd( lua_State *L );
static int systemL_mrkRm( lua_State *L );
static int systemL_createSystem( lua_State *L );
static int systemL_createJump( lua_State *L );
static int systemL_addStar( lua_State *L );
static int systemL_exists( lua_State *L );
static int systemL_createPlanet( lua_State *L );
static int systemL_getLuaData( lua_State *L );
static int systemL_setLuaData( lua_State *L );
static int systemL_getZone( lua_State *L );
static int systemL_setZone( lua_State *L );
static int systemL_setBackground( lua_State *L );
static int systemL_setStars( lua_State *L );

;
static const luaL_reg system_methods[] = {
   { "cur", systemL_cur },
   { "get", systemL_get },
   { "getAll", systemL_getAll },
   { "__eq", systemL_eq },
   { "__tostring", systemL_name },
   { "name", systemL_name },
   { "coords", systemL_coords },
    { "sunSpaceNames", systemL_sunSpaceNames },
   { "faction", systemL_faction },
   { "nebula", systemL_nebula },
   { "jumpDist", systemL_jumpdistance },
   { "jumpPath", systemL_jumpPath },
   { "adjacentSystems", systemL_adjacent },
    { "withinRadius", systemL_withinradius },
   { "jumps", systemL_jumps },
   { "presences", systemL_presences },
   { "planets", systemL_planets },
   { "presence", systemL_presence },
   { "radius", systemL_radius },
   { "known", systemL_isknown },
   { "setKnown", systemL_setknown },
   { "mrkClear", systemL_mrkClear },
   { "mrkAdd", systemL_mrkAdd },
   { "mrkRm", systemL_mrkRm },
   { "createSystem", systemL_createSystem },
   { "createJump", systemL_createJump },
    { "addStar", systemL_addStar },
    { "exists", systemL_exists },
    { "createPlanet", systemL_createPlanet },
    { "getLuaData", systemL_getLuaData },
    { "setLuaData", systemL_setLuaData },
    { "getZone", systemL_getZone },
    { "setZone", systemL_setZone },
	{ "setBackground", systemL_setBackground },
	{ "setStars", systemL_setStars },
{0,0}
}; /**< System metatable methods. */
static const luaL_reg system_cond_methods[] = {
   { "cur", systemL_cur },
   { "get", systemL_get },
   { "getAll", systemL_getAll },
   { "__eq", systemL_eq },
   { "__tostring", systemL_name },
   { "name", systemL_name },
   { "coords", systemL_coords },
   { "sunSpaceNames", systemL_sunSpaceNames },
   { "faction", systemL_faction },
   { "nebula", systemL_nebula },
   { "jumpDist", systemL_jumpdistance },
   { "jumpPath", systemL_jumpPath },
   { "adjacentSystems", systemL_adjacent },
    { "withinRadius", systemL_withinradius },
   { "jumps", systemL_jumps },
   { "presences", systemL_presences },
   { "planets", systemL_planets },
   { "presence", systemL_presence },
   { "radius", systemL_radius },
   { "known", systemL_isknown },
    { "createSystem", systemL_createSystem },
    { "createJump", systemL_createJump },
    { "addStar", systemL_addStar },
    { "exists", systemL_exists },
    { "createPlanet", systemL_createPlanet },
    { "getLuaData", systemL_getLuaData },
    { "setLuaData", systemL_setLuaData },
    { "getZone", systemL_getZone },
    { "setZone", systemL_setZone },
	{ "setBackground", systemL_setBackground },
	{ "setStars", systemL_setStars },
   {0,0}
}; /**< Read only system metatable methods. */


/**
 * @brief Loads the system library.
 *
 *    @param L State to load system library into.
 *    @param readonly Load read only functions?
 *    @return 0 on success.
 */
int nlua_loadSystem( lua_State *L, int readonly )
{
   (void)readonly; /* only read only atm */

   /* Create the metatable */
   luaL_newmetatable(L, SYSTEM_METATABLE);

   /* Create the access table */
   lua_pushvalue(L,-1);
   lua_setfield(L,-2,"__index");

   /* Register the values */
   if (readonly)
      luaL_register(L, NULL, system_cond_methods);
   else
      luaL_register(L, NULL, system_methods);

   /* Clean up. */
   lua_setfield(L, LUA_GLOBALSINDEX, SYSTEM_METATABLE);

   return 0; /* No error */
}


/**
 * @brief Lua system module.
 *
 * This module allows you to use the Star Systems from Lua.
 *
 * Typical example would be something like:
 * @code
 * cur = system.get() -- Gets current system
 * sys = system.get( "Gamma Polaris" )
 * @endcode
 *
 * @luamod system
 */
/**
 * @brief Gets system at index.
 *
 *    @param L Lua state to get system from.
 *    @param ind Index position of system.
 *    @return The LuaSystem at ind.
 */
LuaSystem lua_tosystem( lua_State *L, int ind )
{
   return *((LuaSystem*) lua_touserdata(L,ind));
}
/**
 * @brief Gets system at index raising an error if type doesn't match.
 *
 *    @param L Lua state to get system from.
 *    @param ind Index position of system.
 *    @return The LuaSystem at ind.
 */
LuaSystem luaL_checksystem( lua_State *L, int ind )
{
   if (lua_issystem(L,ind))
      return lua_tosystem(L,ind);
   luaL_typerror(L, ind, SYSTEM_METATABLE);
   return 0;
}

/**
 * @brief Gets system (or system name) at index raising an error if type doesn't match.
 *
 *    @param L Lua state to get system from.
 *    @param ind Index position of system.
 *    @return The System at ind.
 */
StarSystem* luaL_validsystem( lua_State *L, int ind )
{
   LuaSystem ls;
   StarSystem *s;

   if (lua_issystem(L, ind)) {
      ls = luaL_checksystem(L, ind);
      s = system_getIndex( ls );
   }
   else if (lua_isstring(L, ind))
      s = system_get( lua_tostring(L, ind) );
   else {
      luaL_typerror(L, ind, SYSTEM_METATABLE);
      return NULL;
   }

   if (s == NULL)
      NLUA_ERROR(L, "System is invalid");

   return s;
}

/**
 * @brief Pushes a system on the stack.
 *
 *    @param L Lua state to push system onto.
 *    @param sys System to push.
 *    @return System just pushed.
 */
LuaSystem* lua_pushsystem( lua_State *L, LuaSystem sys )
{
   LuaSystem *s;
   s = (LuaSystem*) lua_newuserdata(L, sizeof(LuaSystem));
   *s = sys;
   luaL_getmetatable(L, SYSTEM_METATABLE);
   lua_setmetatable(L, -2);
   return s;
}

/**
 * @brief Checks to see if ind is a system.
 *
 *    @param L Lua state to check.
 *    @param ind Index position to check.
 *    @return 1 if there is a system at index position.
 */
int lua_issystem( lua_State *L, int ind )
{
   int ret;

   if (lua_getmetatable(L,ind)==0)
      return 0;
   lua_getfield(L, LUA_REGISTRYINDEX, SYSTEM_METATABLE);

   ret = 0;
   if (lua_rawequal(L, -1, -2))  /* does it have the correct mt? */
      ret = 1;

   lua_pop(L, 2);  /* remove both metatables */
   return ret;
}


/**
 * @brief Gets the current system.
 *
 * @usage sys = system.cur() -- Gets the current system
 *
 *    @luatreturn System Current system.
 * @luafunc cur()
 */
static int systemL_cur( lua_State *L )
{
   lua_pushsystem(L,system_index( cur_system ));
   return 1;
}


/**
 * @brief Gets a system.
 *
 * Behaves differently depending on what you pass as param: <br/>
 *    - string : Gets the system by name. <br/>
 *    - planet : Gets the system by planet. <br/>
 *
 * @usage sys = system.get( p ) -- Gets system where planet 'p' is located.
 * @usage sys = system.get( "Gamma Polaris" ) -- Gets the system by name.
 *
 *    @luatparam string|Planet param Read description for details.
 *    @luatreturn System System matching param.
 * @luafunc get( param )
 */
static int systemL_get( lua_State *L )
{
   StarSystem *ss;
   Planet *pnt;

   /* Passing a string (systemname) */
   if (lua_isstring(L,1)) {
      ss = system_get( lua_tostring(L,1) );
   }
   /* Passing a planet */
   else if (lua_isplanet(L,1)) {
      pnt = luaL_validplanet(L,1);
      ss = system_get( planet_getSystem( pnt->name ) );
   }
   else NLUA_INVALID_PARAMETER(L);

   /* Error checking. */
   if (ss == NULL) {
      NLUA_ERROR(L, "No matching systems found.");
      return 0;
   }

   /* return the system */
   lua_pushsystem(L,system_index(ss));
   return 1;
}

/**
 * @brief Gets all the systems.
 *    @luatreturn {System,...} A list of all the systems.
 * @luafunc getAll()
 */
static int systemL_getAll( lua_State *L )
{
   StarSystem *sys;
   int i, ind, n;

   lua_newtable(L);
   sys = system_getAll( &n );

   ind = 1;
   for (i=0; i<n; i++) {
      lua_pushnumber( L, ind++ );
      lua_pushsystem( L, system_index( &sys[i] ) );
      lua_settable(   L, -3 );
   }
   return 1;
}

/**
 * @brief checks if a system exists
 *
 *    @luaparam param Name of the system
 *    @luareturn boolean
 * @luafunc get( param )
 */
static int systemL_exists( lua_State *L )
{
    
        if (system_exists( lua_tostring(L,1) )) {
            lua_pushboolean(L,1);
        } else {
            lua_pushboolean(L,0);
        }
    
       return 1;
}

/**
 * @brief Check systems for equality.
 *
 * Allows you to use the '=' operator in Lua with systems.
 *
 * @usage if sys == system.get( "Draygar" ) then -- Do something
 *
 *    @luatparam System s System comparing.
 *    @luatparam System comp System to compare against.
 *    @luatreturn boolean true if both systems are the same.
 * @luafunc __eq( s, comp )
 */
static int systemL_eq( lua_State *L )
{
   LuaSystem a, b;
   a = luaL_checksystem(L,1);
   b = luaL_checksystem(L,2);
   if (a == b)
      lua_pushboolean(L,1);
   else
      lua_pushboolean(L,0);
   return 1;
}

/**
 * @brief Returns the system's name.
 *
 * @usage name = sys:name()
 *
 *    @luatparam System s System to get name of.
 *    @luatreturn string The name of the system.
 * @luafunc name( s )
 */
static int systemL_name( lua_State *L )
{
   StarSystem *sys;
   sys = luaL_validsystem(L,1);
   lua_pushstring(L, sys->name);
   return 1;
}

/**
 * @brief Returns the system's coordinates.
 *
 * @usage x,y = sys:coords()
 *
 *    @luaparam s System to get coords of.
 *    @luareturn The coords of the system.
 * @luafunc name( s )
 */
static int systemL_coords( lua_State *L )
{
    StarSystem *sys;
    sys = luaL_validsystem(L,1);
    lua_pushnumber(L,sys->pos.x);
    lua_pushnumber(L,sys->pos.y);
    return 2;
}

/**
 * @brief Returns the system's gfx_SunSpaceName.
 *
 * @usage name = sys:sunSpaceNames()
 *
 *    @luaparam s System to get gfx_SunSpaceName of.
 *    @luareturn The name of the system.
 * @luafunc name( s )
 */
static int systemL_sunSpaceNames( lua_State *L )
{
    StarSystem *s;
    int i;

    s = luaL_validsystem(L,1);
    
    /* Push all stars. */
    lua_newtable(L);
    for (i=0; i<s->ngfx_SunSpaceNames; i++) {
        lua_pushnumber(L,i+1); /* key, 1-based as normal in lua */
        lua_pushstring(L,s->gfx_SunSpaceNames[i]); /* value */
        lua_rawset(L,-3);
    }
    
    return 1;
}

/**
 * @brief Gets system faction.
 *
 *    @luatparam System s System to get the faction of.
 *    @luatreturn Faction The dominant faction in the system.
 * @luafunc faction( s )
 */
static int systemL_faction( lua_State *L )
{
   StarSystem *s;

   s = luaL_validsystem(L,1);

   if (s->faction == -1)
      return 0;

   lua_pushfaction(L,s->faction);
   return 1;

}


/**
 * @brief Gets the system's nebula parameters.
 *
 * @usage density, volatility = sys:nebula()
 *
 *    @luatparam System s System to get nebula parameters from.
 *    @luatreturn number The density of the system.
 *    @luatreturn number The volatility of the system.
 * @luafunc nebula( s )
 */
static int systemL_nebula( lua_State *L )
{
   StarSystem *s;

   s = luaL_validsystem(L,1);

   /* Push the density and volatility. */
   lua_pushnumber(L, s->nebu_density);
   lua_pushnumber(L, s->nebu_volatility);

   return 2;
}


/**
 * @brief Gets jump distance from current system, or to another.
 *
 * Does different things depending on the parameter type:
 *    - nil : Gets distance from current system.
 *    - string : Gets distance from system matching name.
 *    - system : Gets distance from system
 *
 * @usage d = sys:jumpDist() -- Distance from current system.
 * @usage d = sys:jumpDist( "Draygar" ) -- Distance from system Draygar.
 * @usage d = sys:jumpDist( another_sys ) -- Distance from system another_sys.
 *
 *    @luatparam System s System to get distance from.
 *    @luatparam nil|string|System param See description.
 *    @luatparam[opt=false] boolean hidden Whether or not to consider hidden jumps.
 *    @luatreturn number Number of jumps to system.
 * @luafunc jumpDist( s, param, hidden )
 */
static int systemL_jumpdistance( lua_State *L )
{
   StarSystem *sys, *sysp;
   StarSystem **s;
   int jumps;
   const char *start, *goal;
   int h;

   sys = luaL_validsystem(L,1);
   start = sys->name;
   h   = lua_toboolean(L,3);

   if (lua_gettop(L) > 1) {
      if (lua_isstring(L,2))
         goal = lua_tostring(L,2);
      else if (lua_issystem(L,2)) {
         sysp = luaL_validsystem(L,2);
         goal = sysp->name;
      }
      else NLUA_INVALID_PARAMETER(L);
   }
   else
      goal = cur_system->name;

   s = map_getJumpPath( &jumps, start, goal, 1, h, NULL );
   free(s);

   lua_pushnumber(L,jumps);
   return 1;
}


/**
 * @brief Gets jump path from current system, or to another.
 *
 * Does different things depending on the parameter type:
 *    - nil : Gets path from current system.
 *    - string : Gets path from system matching name.
 *    - system : Gets path from system
 *
 * @usage jumps = sys:jumpPath() -- Path to current system.
 * @usage jumps = sys:jumpPath( "Draygar" ) -- Path from current sys to Draygar.
 * @usage jumps = system.jumpPath( "Draygar", another_sys ) -- Path from Draygar to another_sys.
 *
 *    @luatparam System s System to get path from.
 *    @luatparam nil|string|System param See description.
 *    @luatparam[opt=false] boolean hidden Whether or not to consider hidden jumps.
 *    @luatreturn {Jump,...} Table of jumps.
 * @luafunc jumpPath( s, param, hidden )
 */
static int systemL_jumpPath( lua_State *L )
{
   LuaJump lj;
   StarSystem *sys, *sysp;
   StarSystem **s;
   int i, sid, jumps, pushed, h;
   const char *start, *goal;

   h   = lua_toboolean(L,3);

   /* Foo to Bar */
   if (lua_gettop(L) > 1) {
      sys   = luaL_validsystem(L,1);
      start = sys->name;
      sid   = sys->id;

      if (lua_isstring(L,2))
         goal = lua_tostring(L,2);
      else if (lua_issystem(L,2)) {
         sysp = luaL_validsystem(L,2);
         goal = sysp->name;
      }
      else NLUA_INVALID_PARAMETER(L);
   }
   /* Current to Foo */
   else {
      start = cur_system->name;
      sid   = cur_system->id;
      sys   = luaL_validsystem(L,1);
      goal  = sys->name;
   }

   s = map_getJumpPath( &jumps, start, goal, 1, h, NULL );
   if (s == NULL)
      return 0;

   /* Create the jump table. */
   lua_newtable(L);
   pushed = 0;

   /* Map path doesn't contain the start system, push it manually. */
   lj.srcid  = sid;
   lj.destid = s[0]->id;

   lua_pushnumber(L, ++pushed); /* key. */
   lua_pushjump(L, lj);         /* value. */
   lua_rawset(L, -3);

   for (i=0; i<(jumps - 1); i++) {
      lj.srcid  = s[i]->id;
      lj.destid = s[i+1]->id;

      lua_pushnumber(L, ++pushed); /* key. */
      lua_pushjump(L, lj);         /* value. */
      lua_rawset(L, -3);
   }
   free(s);

   return 1;
}


/**
 * @brief Gets all the adjacent systems to a system.
 *
 * @usage for _,s in ipairs( sys:adjacentSystems() ) do -- Iterate over adjacent systems.
 *
 *    @luatparam System s System to get adjacent systems of.
 *    @luatparam[opt=false] boolean hidden Whether or not to show hidden jumps also.
 *    @luatreturn {System,...} An ordered table with all the adjacent systems.
 * @luafunc adjacentSystems( s, hidden )
 */
static int systemL_adjacent( lua_State *L )
{
   int i, id, h;
   LuaSystem sysp;
   StarSystem *s;

   id = 1;
   s = luaL_validsystem(L,1);
   h = lua_toboolean(L,2);

   /* Push all adjacent systems. */
   lua_newtable(L);
   for (i=0; i<s->njumps; i++) {
      if (jp_isFlag(&s->jumps[i], JP_EXITONLY ))
         continue;
      if (!h && jp_isFlag(&s->jumps[i], JP_HIDDEN))
         continue;
      sysp = system_index( s->jumps[i].target );
      lua_pushnumber(L,id); /* key. */
      lua_pushsystem(L,sysp); /* value. */
      lua_rawset(L,-3);
      id++;
   }

   return 1;
}

/**
 * @brief Gets all the systems within a radius
 *
 * @usage for _,s in ipairs( withinRadius() ) do -- Iterate over found systems.
 *
 *    @luaparam x coord of search centre
 *    @luaparam y coord of search centre
 *    @luaparam radius of the search
 *    @luareturn An ordered table with all the found systems.
 * @luafunc withinRadius( x,y,radius )
 */
static int systemL_withinradius( lua_State *L )
{
    int i, id = 1;
    LuaSystem sysp;
    int systems_nstack ;
    StarSystem *systems_stack= system_getAll( &systems_nstack );
    
    double centreX = luaL_checknumber(L,1);
    double centreY = luaL_checknumber(L,2);
    long radius = luaL_checknumber(L,3);

    long distX,distY;
    
    /* Push all adjacent systems. */
    lua_newtable(L);
    
    for (i=0; i<systems_nstack; i++) {
        distX=systems_stack[i].pos.x-centreX;
        distY=systems_stack[i].pos.y-centreY;
        if (abs(distX)<radius && abs(distY)<radius) {//safety in case of overflow on very large squared distances
        	if (distX*distX+distY*distY<radius*radius) {
        		sysp = system_index(&systems_stack[i]);
        		lua_pushnumber(L,id); /* key. */
        		lua_pushsystem(L,sysp); /* value. */
        		lua_rawset(L,-3);
        		id++;
        	}
        }
    }
    
    return 1;
}


/**
 * @brief Gets all the jumps in a system.
 *
 * @usage for _,s in ipairs( sys:jumps() ) do -- Iterate over jumps.
 *
 *    @luatparam System s System to get the jumps of.
 *    @luatparam[opt=false] boolean exitonly Whether to exclude exit-only jumps.
 *    @luatreturn {Jump,...} An ordered table with all the jumps.
 * @luafunc jumps( s, exitonly )
 */
static int systemL_jumps( lua_State *L )
{
   int i, exitonly, pushed;
   LuaJump lj;
   StarSystem *s;

   s = luaL_validsystem(L,1);
   exitonly = lua_toboolean(L,2);
   pushed = 0;

   /* Push all jumps. */
   lua_newtable(L);
   for (i=0; i<s->njumps; i++) {
      /* Skip exit-only jumps if requested. */
      if ((exitonly) && (jp_isFlag( jump_getTarget( s->jumps[i].target, s ),
            JP_EXITONLY)))
            continue;

      lj.srcid  = s->id;
      lj.destid = s->jumps[i].targetid;
      lua_pushnumber(L,++pushed); /* key. */
      lua_pushjump(L,lj); /* value. */
      lua_rawset(L,-3);
   }

   return 1;
}


/**
 * @brief Returns the factions that have presence in a system and their respective presence values.
 *
 *  @usage if sys:presences()["Empire"] then -- Checks to see if Empire has ships in the system
 *  @usage if sys:presences()[faction.get("Pirate")] then -- Checks to see if the Pirates have ships in the system
 *
 *    @luatparam System s System to get the factional presences of.
 *    @luatreturn {Faction,...} A table with the factions that have presence in the system.
 * @luafunc presences( s )
 */
static int systemL_presences( lua_State *L )
{
   StarSystem *s;
   int i;

   s = luaL_validsystem(L,1);

   /* Return result in table */
   lua_newtable(L);
   for (i=0; i<s->npresence; i++) {
      /* Only return positive presences. */
      if (s->presence[i].value <= 0)
         continue;

      lua_pushstring( L, faction_name(s->presence[i].faction) ); /* t, k */
      lua_pushnumber(L,s->presence[i].value); /* t, k, v */
      lua_settable(L,-3);  /* t */
      /* allows syntax foo = system.presences(); if foo["bar"] then ... end */
   }
   return 1;
}


/**
 * @brief Gets the planets in a system.
 *
 * @usage for key, planet in ipairs( sys:planets() ) do -- Iterate over planets in system
 * @usage if #sys:planets() > 0 then -- System has planets
 *
 *    @luatparam System s System to get planets of
 *    @luatreturn {Planet,...} A table with all the planets
 * @luafunc planets( s )
 */
static int systemL_planets( lua_State *L )
{
   int i, key;
   StarSystem *s;

   s = luaL_validsystem(L,1);

   /* Push all planets. */
   lua_newtable(L);
   key = 0;
   for (i=0; i<s->nplanets; i++) {
      if(s->planets[i]->real == ASSET_REAL) {
         key++;
         lua_pushnumber(L,key); /* key */
         lua_pushplanet(L,planet_index( s->planets[i] )); /* value */
         lua_rawset(L,-3);
      }
   }

   return 1;
}


/**
 * @brief Gets the presence in the system.
 *
 * Possible parameters are besides a faction:<br/>
 *  - "all": Gets the sum of all the presences.<br />
 *  - "friendly": Gets the sum of all the friendly presences.<br />
 *  - "hostile": Gets the sum of all the hostile presences.<br />
 *  - "neutral": Gets the sum of all the neutral presences.<br />
 *
 * @usage p = sys:presence( f ) -- Gets the presence of a faction f
 * @usage p = sys:presence( "all" ) -- Gets the sum of all the presences
 * @usage if sys:presence("friendly") > sys:presence("hostile") then -- Checks to see if the system is dominantly friendly
 *
 *    @luatparam System s System to get presence level of.
 *    @luatreturn number The presence level in sys (absolute value).
 * @luafunc presence( s )
 */
static int systemL_presence( lua_State *L )
{
   StarSystem *sys;
   int *fct;
   int nfct;
   double presence, v;
   int i, f, used;
   const char *cmd;

   /* Get parameters. */
   sys = luaL_validsystem(L, 1);

   /* Allow fall-through. */
   used = 0;

   /* Get the second parameter. */
   if (lua_isstring(L, 2)) {
      /* A string command has been given. */
      cmd  = lua_tostring(L, 2);
      nfct = 0;
      used = 1;

      /* Check the command string and get the appropriate faction group.*/
      if(strcmp(cmd, "all") == 0)
         fct = faction_getGroup(&nfct, 0);
      else if(strcmp(cmd, "friendly") == 0)
         fct = faction_getGroup(&nfct, 1);
      else if(strcmp(cmd, "hostile") == 0)
         fct = faction_getGroup(&nfct, 3);
      else if(strcmp(cmd, "neutral") == 0)
         fct = faction_getGroup(&nfct, 2);
      else /* Invalid command string. */
         used = 0;
   }

   if (!used) {
      /* A faction id was given. */
      f      = luaL_validfaction(L, 2);
      nfct   = 1;
      fct    = malloc(sizeof(int));
      fct[0] = f;
   }

   /* Add up the presence values. */
   presence = 0;
   for(i=0; i<nfct; i++) {
      /* Only count positive presences. */
      v = system_getPresence( sys, fct[i] );
      if (v > 0)
         presence += v;
   }

   /* Clean up after ourselves. */
   free(fct);

   /* Push it back to Lua. */
   lua_pushnumber(L, presence);
   return 1;
}


/**
 * @brief Gets the radius of the system.
 *
 * This is the radius of the circle which all the default jumps will be on.
 *
 * @usage r = s:radius()
 *
 *    @luatparam System s System to get the radius of.
 *    @luatreturn number The radius of the system.
 * @luafunc radius( s )
 */
static int systemL_radius( lua_State *L )
{
   StarSystem *sys;

   /* Get parameters. */
   sys = luaL_validsystem(L, 1);

   lua_pushnumber( L, sys->radius );
   return 1;
}


/**
 * @brief Checks to see if a system is known by the player.
 *
 * @usage b = s:known()
 *
 *    @luatparam System s System to check if the player knows.
 *    @luatreturn boolean true if the player knows the system.
 * @luafunc known( s )
 */
static int systemL_isknown( lua_State *L )
{
   StarSystem *sys = luaL_validsystem(L, 1);
   lua_pushboolean(L, sys_isKnown(sys));
   return 1;
}


/**
 * @brief Sets a system's known state.
 *
 * @usage s:setKnown( false ) -- Makes system unknown.
 *    @luatparam System  s System to set known.
 *    @luatparam[opt=false] boolean b Whether or not to set as known.
 *    @luatparam[opt=false] boolean r Whether or not to iterate over the system's assets and jump points.
 * @luafunc setKnown( s, b, r )
 */
static int systemL_setknown( lua_State *L )
{
   int b, r, i;
   StarSystem *sys;

   r = 0;
   sys = luaL_validsystem(L, 1);
   b   = lua_toboolean(L, 2);
   if (lua_gettop(L) > 2)
      r   = lua_toboolean(L, 3);

   if (b)
      sys_setFlag( sys, SYSTEM_KNOWN );
   else
      sys_rmFlag( sys, SYSTEM_KNOWN );

   if (r) {
      if (b) {
         for (i=0; i < sys->nplanets; i++)
            planet_setKnown( sys->planets[i] );
         for (i=0; i < sys->njumps; i++)
            jp_setFlag( &sys->jumps[i], JP_KNOWN );
     }
     else {
         for (i=0; i < sys->nplanets; i++)
            planet_rmFlag( sys->planets[i], PLANET_KNOWN );
         for (i=0; i < sys->njumps; i++)
            jp_rmFlag( &sys->jumps[i], JP_KNOWN );
     }
   }

   /* Update outfits image array. */
   outfits_updateEquipmentOutfits();

   return 0;
}


/**
 * @brief Clears the system markers.
 *
 * This can be dangerous and clash with other missions, do not try this at home kids.
 *
 * @usage system.mrkClear()
 *
 * @luafunc mrkClear()
 */
static int systemL_mrkClear( lua_State *L )
{
   (void) L;
   ovr_mrkClear();
   return 0;
}


/**
 * @brief Adds a system marker.
 *
 * @usage mrk_id = system.mrkAdd( "Hello", vec2.new( 50, 30 ) ) -- Creates a marker at (50,30)
 *
 *    @luatparam string str String to display next to marker.
 *    @luatparam Vec2 v Position to display marker at.
 *    @luatreturn number The id of the marker.
 * @luafunc mrkAdd( str, v )
 */
static int systemL_mrkAdd( lua_State *L )
{
   const char *str;
   Vector2d *vec;
   unsigned int id;

   /* Handle parameters. */
   str   = luaL_checkstring( L, 1 );
   vec   = luaL_checkvector( L, 2 );

   /* Create marker. */
   id    = ovr_mrkAddPoint( str, vec->x, vec->y );
   lua_pushnumber( L, id );
   return 1;
}


/**
 * @brief Removes a system marker.
 *
 * @usage system.mrkRm( mrk_id ) -- Removes a marker by mrk_id
 *
 *    @luatparam number id ID of the marker to remove.
 * @luafunc mrkRm( id )
 */
static int systemL_mrkRm( lua_State *L )
{
   unsigned int id;
   id = luaL_checklong( L, 1 );
   ovr_mrkRm( id );
   return 0;
}

/**
 * @brief Adds a system.
 *
 * @usage system.createSystem( "name", posX, posY, stars,radius,interference,nebu_volatility,nebu_density,"gfx_BackgroundSpaceName",known) -- Creates a system.
 *
 *    @luaparam name Name of the system. Must not be already taken.
 *    @luaparam posX X coordinate on the map
 *    @luaparam posY Y coordinate on the map
 *    @luaparam stars Star density
 *    @luaparam radius Radius of the system
 *    @luaparam interference
 *    @luaparam nebu_volatility
 *    @luaparam nebu_density
 *    @luaparam background Optional background script to use
 *    @luaparam known Whether the system is known to the player
 *    @luareturn The ID of the NPC to pass to npcRm.
 * @luafunc createSystem( name, posX, posY, stars,radius,background,known )
 */
static int systemL_createSystem( lua_State *L )
{
    StarSystem *sys;
    const char* name;
    double posX,posY;
    int stars;
    double radius,interference,nebu_volatility,nebu_density;
    const char* background;
    const char* zone;
    int known;
    
    /* Handle parameters. */
    name = luaL_checkstring(L, 1);
    posX  = luaL_checknumber(L, 2);
    posY = luaL_checknumber(L, 3);
    stars = luaL_checknumber(L, 4);
    radius = luaL_checknumber(L, 5);
    interference = luaL_checknumber(L, 6);
    nebu_volatility = luaL_checknumber(L, 7);
    nebu_density = luaL_checknumber(L, 8);
    background = luaL_checkstring(L, 9);
    zone = luaL_checkstring(L, 10);
    known = lua_toboolean(L, 11);
    
    
    sys = system_createNewSystem(name);
    
    if (sys==NULL) {
        return -1;
    }
    

    
    sys->pos.x=posX;
    sys->pos.y=posY;
    sys->stars=stars;
    sys->radius=radius;
    sys->interference=interference;
    sys->nebu_volatility=nebu_volatility;
    sys->nebu_density=nebu_density;

    if (background!=NULL && strlen(background)>0)
        sys->background=strdup(background);
    
    if (zone!=NULL && strlen(zone)>0)
        sys->zone=strdup(zone);

    if (known)
        sys_setFlag( sys, SYSTEM_KNOWN );
    
    sys->transient=1;

    return 0;
}

static int systemL_createPlanet( lua_State *L )
{
	int pos=0;

    StarSystem *sys = luaL_validsystem(L, ++pos);
    const char* name = luaL_checkstring(L, ++pos);
    double posX = luaL_checknumber(L, ++pos);
    double posY = luaL_checknumber(L, ++pos);
    const char* spaceGraphic = luaL_checkstring(L, ++pos);
    const char* exteriorGraphic = luaL_checkstring(L, ++pos);
    double presenceAmount = luaL_checknumber(L, ++pos);
    int presenceRange = luaL_checknumber(L, ++pos);
    const char* factionName = luaL_checkstring(L, ++pos);
    const char* description = luaL_checkstring(L, ++pos);
    const char* descriptionSettlements = luaL_checkstring(L, ++pos);
    const char* descriptionHistory = luaL_checkstring(L, ++pos);
    const char* descriptionBar = luaL_checkstring(L, ++pos);
    long population = luaL_checknumber(L, ++pos);
    double hide = luaL_checknumber(L, ++pos);
    const char* class = luaL_checkstring(L, ++pos);
    int serviceLand = luaL_checknumber(L, ++pos);
    const char* landingFunc = luaL_checkstring(L, ++pos);
    int refuel = luaL_checknumber(L, ++pos);
    int bar = luaL_checknumber(L, ++pos);
    int missions = luaL_checknumber(L, ++pos);
    int commodity = luaL_checknumber(L, ++pos);
    int outfits = luaL_checknumber(L, ++pos);
    int shipyard = luaL_checknumber(L, ++pos);
    int known = lua_toboolean(L, ++pos);
    
    if (strlen(factionName)==0)
        factionName=NULL;
    if (strlen(exteriorGraphic)==0)
        exteriorGraphic=NULL;
    if (strlen(description)==0)
        description=NULL;
    if (strlen(descriptionSettlements)==0)
    	descriptionSettlements=NULL;
    if (strlen(descriptionHistory)==0)
    	descriptionHistory=NULL;
    if (strlen(descriptionBar)==0)
        descriptionBar=NULL;
    if (strlen(landingFunc)==0)
        landingFunc=NULL;

    Planet* planet=planet_createNewPlanet( name ,0,spaceGraphic,exteriorGraphic,
                                          posX,posY,presenceAmount,presenceRange,factionName
                                          ,description,descriptionSettlements,descriptionHistory,descriptionBar,population,hide,class,
                                          serviceLand,landingFunc,refuel,bar,missions,commodity,outfits,shipyard);
    
    
    
    if (planet==NULL) {
        return -1;
    }
    
    planet->transient=1;

    system_addPlanet( sys, name );
    
    if (known)
    	planet_setKnown(planet);

    //space_refresh();

    return 0;
}

/**
 * @brief Adds a jump.
 *
 * @usage system.createJump( "sys", "target", bothway) -- Creates a regular jump.
 *
 *    @luaparam name Name of the system in which to create the jump.
 *    @luaparam target Name of the targeted system.
 *    @luaparam bothway If true, create the return jump in the target system.
 *    @luaparam known Whether the player should known the jump
 * @luafunc createJump( "sys", "target", bothway)
 */
static int systemL_createJump( lua_State *L )
{
    StarSystem *sys = luaL_validsystem(L, 1);
    StarSystem *target = luaL_validsystem(L, 2);
    int bothway = lua_toboolean(L, 3);
    int known = lua_toboolean(L, 4);
    int alreadyExists=0;
    int i;
    
    for (i=0;i<sys->njumps;i++) {
    	if (sys->jumps[i].target==target)
    		alreadyExists=1;
    }

    if (!alreadyExists)
    	system_addJumpPoint(sys,target,0,0,-1,-1,1,0,0,1,known);

    if (bothway==1) {
    	alreadyExists=0;

    	for (i=0;i<target->njumps;i++) {
			if (target->jumps[i].target==sys)
				alreadyExists=1;
		}

    	if (!alreadyExists)
    		system_addJumpPoint(target,sys,0,0,-1,-1,1,0,0,1,known);
    }
    
    systems_reconstructJumps();
    
    return 0;
}

/**
 * @brief Adds a star graphic to the system.
 *
 * @usage system.addStar( "sys", "star") -- Adds a star graphic to the system.
 *
 *    @luaparam name Name of the system in which to create the star.
 *    @luaparam target Name of the star graphic (the PNG file).
 * @luafunc addStar( "sys", "star")
 */
static int systemL_addStar( lua_State *L )
{
    StarSystem *sys = luaL_validsystem(L, 1);
    const char* name = luaL_checkstring(L, 2);

    system_addStar(sys,strdup(name));
    
    return 0;
}

/**
 * @brief Gets the lua data
 *
 * @uasge gfx = sys:getLuaData()
 *    @luaparam sys System to get lua data of.
 *    @luareturn The lua data of the system.
 * @luafunc getLuaData( p )
 */
static int systemL_getLuaData( lua_State *L )
{
	StarSystem *sys = luaL_validsystem(L, 1);
   if (sys->luaData == NULL)
	   lua_pushstring(L,"{}");
   else
	   lua_pushstring(L,sys->luaData);
   return 1;
}


/**
 * @brief Sets a system's lua data.
 *
 * @usage p:setLuaData( luaData ) sets lua data
 *    @luaparam p System to set lua data for.
 *    @luaparam b lua data
 * @luafunc setLuaData( s, b )
 */
static int systemL_setLuaData( lua_State *L )
{
   StarSystem *sys = luaL_validsystem(L, 1);
   sys->luaData=strdup(lua_tostring(L, 2));

   return 0;
}

/**
 * @brief Gets the zone
 *
 * @usage gfx = sys:getZone()
 *    @luaparam sys System to get zone of.
 *    @luareturn The zone of the system.
 * @luafunc getZone( p )
 */
static int systemL_getZone( lua_State *L )
{
	StarSystem *sys = luaL_validsystem(L, 1);
   lua_pushstring(L,sys->zone);
   return 1;
}


/**
 * @brief Sets a system's zone.
 *
 * @usage p:setZone( zone ) sets zone
 *    @luaparam p System to set zone for.
 *    @luaparam b zone
 * @luafunc setZone( s, b )
 */
static int systemL_setZone( lua_State *L )
{
   StarSystem *sys = luaL_validsystem(L, 1);
   sys->zone=strdup(lua_tostring(L, 2));

   return 0;
}

/**
 * @brief Sets a system's background script.
 *
 * @usage p:setBackground( zone ) sets zone
 *    @luaparam p System to set background for.
 *    @luaparam b background
 * @luafunc setZone( s, b )
 */
static int systemL_setBackground( lua_State *L )
{
   StarSystem *sys = luaL_validsystem(L, 1);
   sys->background=strdup(lua_tostring(L, 2));

   return 0;
}

/**
 * @brief Sets a system's background star number.
 *
 * @usage p:setStars( number ) sets star number
 *    @luaparam p System to set star number for.
 *    @luaparam n star number
 * @luafunc setStars( s, n )
 */
static int systemL_setStars( lua_State *L )
{
   StarSystem *sys = luaL_validsystem(L, 1);
   sys->stars=(int)luaL_checknumber(L, 2);

   return 0;
}

