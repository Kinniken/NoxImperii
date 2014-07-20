/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file dev_planet.c
 *
 * @brief Handles the planet stuff.
 */

#include "dev_planet.h"
#include "dev_uniedit.h"

#include "naev.h"

#include <stdlib.h> /* qsort */

#include "nxml.h"
#include "physics.h"
#include "nfile.h"
#include "nstring.h"
#include "space.h"


/**
 * @brief Saves a planet.
 *
 *    @param writer Write to use for saving the star planet.
 *    @param p Planet to save.
 *    @return 0 on success.
 */
int dpl_savePlanet( const Planet *p )
{
   xmlDocPtr doc;
   xmlTextWriterPtr writer;
   char *file, *cleanName;
   int len;

   /* Create the writer. */
   writer = xmlNewTextWriterDoc(&doc, 0);
   if (writer == NULL) {
      WARN("testXmlwriterDoc: Error creating the xml writer");
      return -1;
   }

   /* Set the writer parameters. */
   xmlw_setParams( writer );

   /* Start writer. */
   xmlw_start(writer);

   planet_savePlanet(writer,p,0);

   xmlw_done( writer );

   /* No need for writer anymore. */
   xmlFreeTextWriter( writer );

   /* Write data. */
   cleanName = uniedit_nameFilter( p->name );
   len       = strlen(cleanName)+16;
   file      = malloc( len*sizeof(char) );
   nsnprintf( file, len, "dat/assets/%s.xml", cleanName );
   xmlSaveFileEnc( file, doc, "UTF-8" );
   free( file );

   /* Clean up. */
   xmlFreeDoc(doc);
   free(cleanName);

   return 0;
}


/**
 * @brief Saves all the star planets.
 *
 *    @return 0 on success.
 */
int dpl_saveAll (void)
{
   int i;
   int np;
   const Planet *p;

   p = planet_getAll( &np );

   /* Write planets. */
   for (i=0; i<np; i++)
      dpl_savePlanet( &p[i] );

   return 0;
}


