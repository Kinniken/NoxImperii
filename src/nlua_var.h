/*
 * See Licensing and Copyright notice in naev.h
 */


#ifndef NLUA_VAR
#  define NLUA_VAR

#include <lua.h>

#include "nlua.h"


/* checks if a flag exists on the variable stack */
int var_checkflag( char* str );
void var_cleanup (void);

/* individual library stuff */
int nlua_loadVar( nlua_env env );

char* var_read_str( const char* name );
double* var_read_num( const char* name );
int* var_read_bool( const char* name );

#endif /* NLUA_VAR */
