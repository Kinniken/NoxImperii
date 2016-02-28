/*
 * See Licensing and Copyright notice in naev.h
 */



#ifndef ECONOMY_H
#  define ECONOMY_H


#include <stdint.h>
#include "opengl.h"

#define ECON_CRED_STRLEN      32 /**< Maximum length a credits2str string can reach. */
#define TRADE_REFILL_DURATION ((1000.0*10000.0)*100.0) /* Duration necessary for planet to replenish trade goods, in STP outside inner brackets */


typedef int64_t credits_t;
#define CREDITS_MAX        INT64_MAX
#define CREDITS_MIN        INT64_MIN
#define CREDITS_PRI        PRIu64

/**
 * @struct Commodity
 *
 * @brief Represents a commodity.
 *
 * @todo Use inverse normal?
 */
typedef struct Commodity_ {
   char* name; /**< Name of the commodity. */
   char* description; /**< Description of the commodity. */
   /* Prices. */
   double price; /**< Base price of the commodity. */
   glTexture* gfx_store; /**< Store graphic. */
   int id; /** order from the XML file. Used for sorting trade data. **/
} Commodity;


/*
 * Commodity stuff.
 */
Commodity* commodity_get( const char* name );
Commodity* commodity_getW( const char* name );
int commodity_load (void);
void commodity_free (void);


/*
 * Misc stuff.
 */
void credits2str( char *str, credits_t credits, int decimals );
void price2str( char *str, credits_t price, credits_t credits, int decimals );
void commodity_Jettison( int pilot, Commodity* com, int quantity );
int commodity_compareTech( const void *commodity1, const void *commodity2 );


#endif /* ECONOMY_H */
