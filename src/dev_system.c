/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file dev_system.c
 *
 * @brief Handles development of star system stuff.
 */

#include "dev_system.h"
#include "dev_uniedit.h"

#include "naev.h"

#include <stdlib.h> /* qsort */

#include "nxml.h"
#include "space.h"
#include "physics.h"
#include "nstring.h"


/*
 * Prototypes.
 */







/**
 * @brief Saves a star system.
 *
 *    @param writer Write to use for saving the star system.
 *    @param sys Star system to save.
 *    @return 0 on success.
 */
int dsys_saveSystem( StarSystem *sys )
{
   int len;
   xmlDocPtr doc;
   xmlTextWriterPtr writer;
   char *file, *cleanName;


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

   system_saveSystem(writer,sys,0);

   xmlw_done(writer);

   /* No need for writer anymore. */
   xmlFreeTextWriter(writer);

   /* Write data. */
   cleanName = uniedit_nameFilter( sys->name );
   len       = (strlen(cleanName)+14);
   file      = malloc( len );
   nsnprintf( file, len, "dat/ssys/%s.xml", cleanName );
   xmlSaveFileEnc( file, doc, "UTF-8" );
   free( file );

   /* Clean up. */
   xmlFreeDoc(doc);
   free(cleanName);

   return 0;
}


/**
 * @brief Saves all the star systems.
 *
 *    @return 0 on success.
 */
int dsys_saveAll (void)
{
   int i;
   int nsys;
   StarSystem *sys;

   sys = system_getAll( &nsys );

   /* Write systems. */
   for (i=0; i<nsys; i++)
      dsys_saveSystem( &sys[i] );

   return 0;
}
/**
 * @brief Saves selected systems as a map outfit file.
 *
 *    @return 0 on success.
 */
int dsys_saveMap (StarSystem **uniedit_sys, int uniedit_nsys)
{
   int i, j, k, len;
   xmlDocPtr doc;
   xmlTextWriterPtr writer;
   StarSystem *s;
   char *file, *cleanName;

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
   xmlw_startElem( writer, "outfit" );

   /* Attributes. */
   xmlw_attr( writer, "name", "Editor-generated Map" );

   /* General. */
   xmlw_startElem( writer, "general" );
   xmlw_elem( writer, "mass", "%d", 0 );
   xmlw_elem( writer, "price", "%d", 1000 );
   xmlw_elem( writer, "description", "%s", "This map has been created by the universe editor." );
   xmlw_elem( writer, "gfx_store", "%s", "map" );
   xmlw_endElem( writer ); /* "general" */

   xmlw_startElem( writer, "specific" );
   xmlw_attr( writer, "type", "map" );

   /* Iterate over all selected systems. Save said systems and any NORMAL jumps they might share. */
   for (i = 0; i < uniedit_nsys; i++) {
      s = uniedit_sys[i];
      xmlw_startElem( writer, "sys" );
      xmlw_attr( writer, "name", s->name, "" );

      /* Iterate jumps and see if they lead to any other systems in our array. */
      for (j = 0; j < s->njumps; j++) {
         /* Ignore hidden and exit-only jumps. */
         if (jp_isFlag(&s->jumps[j], JP_EXITONLY ))
            continue;
         if (jp_isFlag(&s->jumps[j], JP_HIDDEN))
            continue;
         /* This is a normal jump. */
         for (k = 0; k < uniedit_nsys; k++) {
            if (s->jumps[j].target == uniedit_sys[k]) {
               xmlw_elem( writer, "jump", "%s", uniedit_sys[k]->name );
               break;
            }
         }
      }

      /* Iterate assets and add them */
      for (j = 0; j < s->nplanets; j++) {
         if (s->planets[j]->real)
            xmlw_elem( writer, "asset", "%s", s->planets[j]->name );
      }

      xmlw_endElem( writer ); /* "sys" */
   }

   xmlw_endElem( writer ); /* "specific" */
   xmlw_endElem( writer ); /* "outfit" */
   xmlw_done(writer);

   /* No need for writer anymore. */
   xmlFreeTextWriter(writer);

   /* Write data. */
   cleanName = uniedit_nameFilter( "saved map" );
   len       = (strlen(cleanName)+22);
   file      = malloc( len );
   nsnprintf( file, len, "dat/outfits/maps/%s.xml", cleanName );
   xmlSaveFileEnc( file, doc, "UTF-8" );
   free( file );

   /* Clean up. */
   xmlFreeDoc(doc);
   free(cleanName);

   return 0;
}


