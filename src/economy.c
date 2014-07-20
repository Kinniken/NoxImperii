/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file economy.c
 *
 * @brief Handles economy stuff.
 *
 * Economy is handled with Nodal Analysis.  Systems are modelled as nodes,
 *  jump routes are resistances and production is modelled as node intensity.
 *  This is then solved with linear algebra after each time increment.
 */


#include "economy.h"

#include "naev.h"

#include <stdio.h>
#include "nstring.h"
#include <stdint.h>

#ifdef HAVE_SUITESPARSE_CS_H
#include <suitesparse/cs.h>
#else
#include <cs.h>
#endif

#include "nxml.h"
#include "ndata.h"
#include "log.h"
#include "spfx.h"
#include "pilot.h"
#include "rng.h"
#include "space.h"
#include "ntime.h"



#define XML_COMMODITY_ID      "Commodities" /**< XML document identifier */
#define XML_COMMODITY_TAG     "commodity" /**< XML commodity identifier. */


/*
 * Economy Nodal Analysis parameters.
 */
#define ECON_BASE_RES      30. /**< Base resistance value for any system. */
#define ECON_SELF_RES      3. /**< Additional resistance for the self node. */
#define ECON_FACTION_MOD   0.1 /**< Modifier on Base for faction standings. */
#define ECON_PROD_MODIFIER 500000. /**< Production modifier, divide production by this amount. */
#define ECON_PROD_VAR      0.01 /**< Defines the variability of production. */

/* commodity stack */
static Commodity* commodity_stack = NULL; /**< Contains all the commodities. */
static int commodity_nstack       = 0; /**< Number of commodities in the stack. */


/* systems stack. */
extern StarSystem *systems_stack; /**< Star system stack. */
extern int systems_nstack; /**< Number of star systems. */


/*
 * Nodal analysis simulation for dynamic economies.
 */

static int *econ_comm         = NULL; /**< Commodities to calculate. */
static int econ_nprices       = 0; /**< Number of prices to calculate. */


/*
 * Prototypes.
 */
/* Commodity. */
static int commodity_parse( Commodity *temp, xmlNodePtr parent );

/**
 * @brief Converts credits to a usable string for displaying.
 *
 *    @param[out] str Output is stored here, must have at least a length of 32
 *                     char.
 *    @param credits Credits to display.
 *    @param decimals Decimals to use.
 */
void credits2str( char *str, credits_t credits, int decimals )
{
   if (decimals < 0)
      nsnprintf( str, ECON_CRED_STRLEN, "%"CREDITS_PRI, credits );
   else if (credits >= 1000000000000000LL)
      nsnprintf( str, ECON_CRED_STRLEN, "%.*fQ", decimals, (double)credits / 1000000000000000. );
   else if (credits >= 1000000000000LL)
      nsnprintf( str, ECON_CRED_STRLEN, "%.*fT", decimals, (double)credits / 1000000000000. );
   else if (credits >= 1000000000L)
      nsnprintf( str, ECON_CRED_STRLEN, "%.*fB", decimals, (double)credits / 1000000000. );
   else if (credits >= 1000000)
      nsnprintf( str, ECON_CRED_STRLEN, "%.*fM", decimals, (double)credits / 1000000. );
   else if (credits >= 1000)
      nsnprintf( str, ECON_CRED_STRLEN, "%.*fK", decimals, (double)credits / 1000. );
   else
      nsnprintf (str, ECON_CRED_STRLEN, "%"CREDITS_PRI, credits );
}


/**
 * @brief Gets a commodity by name.
 *
 *    @param name Name to match.
 *    @return Commodity matching name.
 */
Commodity* commodity_get( const char* name )
{
   int i;
   for (i=0; i<commodity_nstack; i++)
      if (strcmp(commodity_stack[i].name,name)==0)
         return &commodity_stack[i];

   WARN("Commodity '%s' not found in stack", name);
   return NULL;
}


/**
 * @brief Gets a commodity by name without warning.
 *
 *    @param name Name to match.
 *    @return Commodity matching name.
 */
Commodity* commodity_getW( const char* name )
{
   int i;
   for (i=0; i<commodity_nstack; i++)
      if (strcmp(commodity_stack[i].name,name)==0)
         return &commodity_stack[i];
   return NULL;
}



/**
 * @brief Function meant for use with C89, C99 algorithm qsort().
 *
 *    @param commodity1 First argument to compare.
 *    @param commodity2 Second argument to compare.
 *    @return -1 if first argument is inferior, +1 if it's superior, 0 if ties.
 */
int commodity_compareTech( const void *commodity1, const void *commodity2 )
{
   const Commodity *c1, *c2;

   /* Get commodities. */
   c1 = * (const Commodity**) commodity1;
   c2 = * (const Commodity**) commodity2;

   /* Compare price. */
   if (c1->price < c2->price)
      return +1;
   else if (c1->price > c2->price)
      return -1;

   /* It turns out they're the same. */
   return strcmp( c1->name, c2->name );
}


/**
 * @brief Loads a commodity.
 *
 *    @param temp Commodity to load data into.
 *    @param parent XML node to load from.
 *    @return Commodity loaded from parent.
 */
static int commodity_parse( Commodity *temp, xmlNodePtr parent )
{
   xmlNodePtr node;

   /* Clear memory. */
   memset( temp, 0, sizeof(Commodity) );

   /* Get name. */
   xmlr_attr( parent, "name", temp->name );
   if (temp->name == NULL)
      WARN("Commodity from "COMMODITY_DATA_PATH" has invalid or no name");

   /* Parse body. */
   node = parent->xmlChildrenNode;
   do {
      xml_onlyNodes(node);
      xmlr_strd(node, "description", temp->description);
      xmlr_int(node, "price", temp->price);
      WARN("Commodity '%s' has unknown node '%s'.", temp->name, node->name);
   } while (xml_nextNode(node));

#if 0 /* shouldn't be needed atm */
#define MELEMENT(o,s)   if (o) WARN("Commodity '%s' missing '"s"' element", temp->name)
   MELEMENT(temp->description==NULL,"description");
   MELEMENT(temp->high==0,"high");
   MELEMENT(temp->medium==0,"medium");
   MELEMENT(temp->low==0,"low");
#undef MELEMENT
#endif

   return 0;
}


/**
 * @brief Throws cargo out in space graphically.
 *
 *    @param pilot ID of the pilot throwing the stuff out
 *    @param com Commodity to throw out.
 *    @param quantity Quantity thrown out.
 */
void commodity_Jettison( int pilot, Commodity* com, int quantity )
{
   (void)com;
   int i;
   Pilot* p;
   int n, effect;
   double px,py, bvx, bvy, r,a, vx,vy;

   p   = pilot_get( pilot );

   n   = MAX( 1, RNG(quantity/10, quantity/5) );
   px  = p->solid->pos.x;
   py  = p->solid->pos.y;
   bvx = p->solid->vel.x;
   bvy = p->solid->vel.y;
   for (i=0; i<n; i++) {
      effect = spfx_get("cargo");

      /* Radial distribution gives much nicer results */
      r  = RNGF()*25 - 12.5;
      a  = 2. * M_PI * RNGF();
      vx = bvx + r*cos(a);
      vy = bvy + r*sin(a);

      /* Add the cargo effect */
      spfx_add( effect, px, py, vx, vy, SPFX_LAYER_BACK );
   }
}


/**
 * @brief Loads all the commodity data.
 *
 *    @return 0 on success.
 */
int commodity_load (void)
{
   uint32_t bufsize;
   char *buf;
   xmlNodePtr node;
   xmlDocPtr doc;

   /* Load the file. */
   buf = ndata_read( COMMODITY_DATA_PATH, &bufsize);
   if (buf == NULL)
      return -1;

   /* Handle the XML. */
   doc = xmlParseMemory( buf, bufsize );
   if (doc == NULL) {
      WARN("'%s' is not valid XML.", COMMODITY_DATA_PATH);
      return -1;
   }

   node = doc->xmlChildrenNode; /* Commodities node */
   if (strcmp((char*)node->name,XML_COMMODITY_ID)) {
      ERR("Malformed "COMMODITY_DATA_PATH" file: missing root element '"XML_COMMODITY_ID"'");
      return -1;
   }

   node = node->xmlChildrenNode; /* first faction node */
   if (node == NULL) {
      ERR("Malformed "COMMODITY_DATA_PATH" file: does not contain elements");
      return -1;
   }

   do {
      xml_onlyNodes(node);
      if (xml_isNode(node, XML_COMMODITY_TAG)) {

         /* Make room for commodity. */
         commodity_stack = realloc(commodity_stack,
               sizeof(Commodity)*(++commodity_nstack));

         /* Load commodity. */
         commodity_parse(&commodity_stack[commodity_nstack-1], node);

         /* See if should get added to commodity list. */
         if (commodity_stack[commodity_nstack-1].price > 0.) {
            econ_nprices++;
            econ_comm = realloc(econ_comm, econ_nprices * sizeof(int));
            econ_comm[econ_nprices-1] = commodity_nstack-1;
         }
      }
      else
         WARN("'"COMMODITY_DATA_PATH"' has unknown node '%s'.", node->name);
   } while (xml_nextNode(node));

   xmlFreeDoc(doc);
   free(buf);

   DEBUG("Loaded %d Commodit%s", commodity_nstack, (commodity_nstack==1) ? "y" : "ies" );

   return 0;
}






